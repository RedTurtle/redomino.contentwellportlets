#!/usr/bin/env bash
cd $(dirname $0)
rm ./rebuild_i18n.log
domain="redomino.contentwellportlets"

i18ndude rebuild-pot --pot ./$domain.pot --merge ./$domain-manual.pot --create $domain ../ ../profiles ../browser || exit 1
i18ndude sync        --pot ./$domain.pot ./*/LC_MESSAGES/$domain.po

i18ndude rebuild-pot --pot ../i18n/$domain.pot --merge ../i18n/$domain-manual.pot --create plone ../ ../profiles ../browser || exit 1
i18ndude sync        --pot ../i18n/$domain.pot ../i18n/$domain-*.po

WARNINGS=`find . -name "*pt" | xargs i18ndude find-untranslated | grep -e '^-WARN' | wc -l`
ERRORS=`find . -name "*pt" | xargs i18ndude find-untranslated | grep -e '^-ERROR' | wc -l`
FATAL=`find . -name "*pt"  | xargs i18ndude find-untranslated | grep -e '^-FATAL' | wc -l`

echo
echo There are $ERRORS errors \(almost definitely missing i18n markup\)
echo There are $WARNINGS warnings \(possibly missing i18n markup\)
echo There are $FATAL fatal errors \(template could not be parsed, eg. if it\'s not html\)
echo For more details, run \'find . -name \"\*pt\" \| xargs i18ndude find-untranslated\' or 
echo Look the rebuild i18n log generate for this script called \'rebuild_i18n.log\' on locales dir 

touch ./rebuild_i18n.log

find . -name "*pt" | xargs i18ndude find-untranslated > rebuild_i18n.log


