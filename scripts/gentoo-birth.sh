# Attention ! This works in french installations, change the word "Créé" to your local word
stat / | grep 'Créé' | sed 's/  Créé ://g' | cut -b 2-11 | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})/\3-\2-\1/'
