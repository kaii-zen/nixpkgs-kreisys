{ lib, pkgs, config, ... }:

let
  inherit (config.services) consul zerotierone;
  inherit (zerotierone) apiToken;
  authorizeMember = pkgs.writeShellScriptBin "authorize-member" ''
    set -e

    PATH=${pkgs.nettools}/bin:$PATH

    if [[ $(jq -r '\(.Value)' 2>/dev/null || true) == success ]]; then
      exit
    fi

    STATUS=fail

    NODE=$1
    NET_ID=$2
    MEMBER_ID=$3

    PREFIX=zerotier/authorizer/locks
    KEY="$PREFIX/$(echo "$@" | sha1sum | cut -d' ' -f1)"

    eval "$(curl --silent --request PUT http://localhost:8500/v1/session/create | jq -r '@sh "export SESSION=\(.ID)"')"
    export LEADER=$(curl --silent -X PUT http://localhost:8500/v1/kv/$KEY?acquire=$SESSION)

    release_lock() {
      curl --silent --data $STATUS -X PUT http://localhost:8500/v1/kv/$KEY?release=$SESSION &>/dev/null
    }

    trap release_lock EXIT

    if $LEADER; then
      echo 👸🏾 Authorizing $NODE
      echo "{ \"Node\": \"$NODE\", \"Me\": \"$(hostname)\" }" | jq --raw-output '{ name: .Node, description: "Authorized by \(.Me)", config: { authorized: true } }' | \
        curl --silent --header "Authorization: Bearer $API_TOKEN" --request POST --data @- https://my.zerotier.com/api/network/$NET_ID/member/$MEMBER_ID &>/dev/null
      STATUS=success
      sleep 60
    else
      echo 💅🏾
      exec consul watch -type=key -key=$KEY handle-zerotier-access-denied
    fi
  '';

  consulOnce = pkgs.writeShellScriptBin "consul-once" ''
    set -e

    PATH=${pkgs.gawk}/bin:$PATH

    PREFIX=$1
    KEY="$PREFIX/$(echo "$@" | sha1sum | awk '{print $1}')"

    consul lock -monitor-retry=5 $PREFIX "$(cat <<EOF
      if ! consul kv get "$KEY" &> /dev/null; then
        $@
        consul kv put "$KEY" &> /dev/null
      fi
    EOF
    )"
  '';

  handleZerotierAccessDenied = pkgs.writeShellScriptBin "handle-zerotier-access-denied" ''
    set -e

    #eval "$(jq -r '@sh "export PREV_STATUS=\(.Value)"')"

    #if [[ $PREV_STATUS == success ]]; then
    #  exit
    #fi

    #STATUS=fail

    #eval "$(curl --silent --request PUT http://localhost:8500/v1/session/create | jq -r '@sh "export SESSION=\(.ID)"')"
    #export LEADER=$(curl --silent -X PUT http://localhost:8500/v1/kv/zerotier/authorizer/leader?acquire=$SESSION)

    #release_lock() {
    #  curl --silent --data $STATUS -X PUT http://localhost:8500/v1/kv/zerotier/authorizer/leader?release=$SESSION
    #}

    #trap release_lock EXIT

    #if ! $LEADER; then
    #  echo Not leader. Watching leader.
    #  exec consul watch -type=key -key=zerotier/authorizer/leader handle-zerotier-access-denied
    #fi

    (jq -r '.[] | select((.CheckID | startswith("zerotier-net")) and (.Output == "ACCESS_DENIED")) | { NetId: (.CheckID | ltrimstr("zerotier-net-")), Node } | "\(.NetId) \(.Node)"' 2> /dev/null || true) | while read NET_ID NODE; do
      eval "$(consul watch -type=nodes | jq --raw-output ".[] | select(.Node == \"$NODE\") | @sh \"MEMBER_ID=\(.Meta[\"zerotier-id\"])\"")"
      authorize-member $NODE $NET_ID $MEMBER_ID
    done

    #STATUS=success
  '';

in {
  config = lib.mkIf (apiToken != null && consul.enable && zerotierone.enable) {
    systemd = {
      services.consul-zerotier-access-denied-watcher = {
        description = "Authorize nodes to connect to Zerotier networks";
        wantedBy    = [ "multi-user.target" ];
        requires    = [ "consul.service" ];
        after       = [ "consul.service" ];
        path        = with pkgs; [ authorizeMember consulOnce curl handleZerotierAccessDenied jq config.services.consul.package ];

        environment.API_TOKEN = apiToken;

        script = ''
          set -e
          consul watch -type=checks -state=critical handle-zerotier-access-denied

        '';

        serviceConfig.Restart = "always";
      };
    };
  };
}
