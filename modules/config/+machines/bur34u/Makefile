files := \
	/etc/environment.d/90-proxy.conf \
	/etc/gitconfig.d/proxy.conf

.PHONY: all glab $(files)
all: glab $(files) 

glab:
	@host="$${GITLAB_HOST}"; \
	host="$${host#https://}"; \
	host="$${host#http://}"; \
	current="$$(glab config get host --global 2>/dev/null || true)"; \
	if [ "$$current" = "$$host" ]; then \
		printf '  \033[0;90m  up-to-date\033[0m %s\n' "glab host: $$host"; \
	else \
		glab config set host "$$host" --global; \
		printf '  \033[0;36m  updated\033[0m %s\n' "glab host: $$host"; \
	fi

/etc/environment.d/90-proxy.conf: modules/proxy/90-proxy.conf.in
	@tmp="$$(mktemp)"; \
	trap 'rm -f "$$tmp"' EXIT; \
	http_proxy="$${http_proxy:-$${HTTP_PROXY:-}}" \
	https_proxy="$${https_proxy:-$${HTTPS_PROXY:-$${http_proxy:-$${HTTP_PROXY:-}}}}" \
	all_proxy="$${all_proxy:-$${ALL_PROXY:-}}" \
	no_proxy="$${no_proxy:-$${NO_PROXY:-}}" \
	HTTP_PROXY="$${HTTP_PROXY:-$${http_proxy:-}}" \
	HTTPS_PROXY="$${HTTPS_PROXY:-$${https_proxy:-$${http_proxy:-}}}" \
	ALL_PROXY="$${ALL_PROXY:-$${all_proxy:-}}" \
	NO_PROXY="$${NO_PROXY:-$${no_proxy:-}}" \
	envsubst < "$<" > "$$tmp"; \
	if [ -e "$@" ] && cmp -s "$$tmp" "$@"; then \
		printf '  \033[0;90m  up-to-date\033[0m %s\n' "$@"; \
	else \
		if [ -e "$@" ]; then action=updated; else action=generated; fi; \
		printf '  \033[0;36m  %s\033[0m %s\n' "$$action" "$@"; \
		sudo install -D -m 0644 "$$tmp" "$@"; \
	fi

/etc/gitconfig.d/proxy.conf: modules/proxy/gitconfig.conf.in
	@tmp="$$(mktemp)"; \
	trap 'rm -f "$$tmp"' EXIT; \
	git_proxy="$${https_proxy:-$${HTTPS_PROXY:-$${http_proxy:-$${HTTP_PROXY:-}}}}"; \
	if [ -n "$$git_proxy" ]; then \
		git_proxy="$$git_proxy" envsubst < "$<" > "$$tmp"; \
		action=updated; \
	else \
		: > "$$tmp"; \
		action=clear; \
	fi; \
	if [ -e "$@" ] && cmp -s "$$tmp" "$@"; then \
		printf '  \033[0;90m  up-to-date\033[0m %s\n' "$@"; \
	else \
		if [ "$$action" = updated ] && [ ! -e "$@" ]; then action=generated; fi; \
		if [ "$$action" = clear ]; then color=33; else color=36; fi; \
		printf '  \033[0;%sm  %s\033[0m %s\n' "$$color" "$$action" "$@"; \
		sudo install -D -m 0644 "$$tmp" "$@"; \
	fi


