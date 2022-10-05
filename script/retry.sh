#!/usr/bin/env bash

# Sorting final zip
compiled_zip() {
	ZIP=$(find $(pwd)/out/target/product/lava/ -maxdepth 1 -name "*lava*.zip" | perl -e 'print sort { length($b) <=> length($a) } <>' | head -n 1)
	ZIPNAME=$(basename ${ZIP})
}

# Retry the ccache fill for 99-100% hit rate
retry_ccache () {
	export CCACHE_DIR=/tmp/ccache
	export CCACHE_EXEC=$(which ccache)
	ccache -s
	hit_rate=$(ccache -s | awk 'NR==2 { print $5 }' | tr -d '(' | cut -d'.' -f1)
	if [[ $hit_rate -lt 100 && ! -f out/build_error ]]; then
		echo "Ccache is not fully configured"
		git clone https://${TOKEN}@github.com/BoxBoxBoxBoxBox/sus cirrus && cd $_
		git commit --allow-empty -m "Retry: Ccache loop $(date -u +"%D %T%p %Z")"
		git push -q
	elif [[  -f out/build_error ]]; then
		echo "Build error occured; Ccache refill is halted"
	else
		echo "Ccache is fully configured"
	fi
}

# Trigger retry only if compilation is not finished
retry_event() {
	if [ -f $(pwd)/out/target/product/lava/${ZIPNAME} ]; then
		echo "Successful Build"
	else
		retry_ccache
	fi
}

cd /tmp/rom && sleep 115m
compiled_zip
retry_event
