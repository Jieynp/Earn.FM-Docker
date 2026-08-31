FROM cba44/external-ip:latest AS external-ip

FROM earnfm/earnfm-client:latest

COPY --from=external-ip /ipweb /ipweb

RUN chmod +x /ipweb

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "-c", "set -eu; /ipweb & external_ip_pid=$!; /app/main & earnfm_client_pid=$!; trap 'kill \"$external_ip_pid\" \"$earnfm_client_pid\" 2>/dev/null || true' INT TERM EXIT; while kill -0 \"$external_ip_pid\" 2>/dev/null && kill -0 \"$earnfm_client_pid\" 2>/dev/null; do sleep 1; done; exit 1"]
