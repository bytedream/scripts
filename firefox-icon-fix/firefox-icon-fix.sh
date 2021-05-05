install_path=/usr/lib/firefox*

skipping=false
fixed_file=$(readlink -f firefox.png)

for file in $(find $install_path -type f,l -name "default*.png" && find /usr/share/icons -type f,l -name "firefox*.png")
do
    if [ "$#" -ge 1 ] && [ $1 == "unfix" ]; then
        if [ -f "$file.bak" ]; then
            rm $file
            mv "$file.bak" $file
            echo "Unfixed file $file"
        else
            echo "Skipped file $file since no backup of it exists"
        fi
    elif [ -f "$file.bak" ]; then
        if [ "$#" -ge 1 ] && [ $1 == "--overwrite" ]; then
            mv $file "$file.bak"
            ln -s -r firefox-icon-fix.png $file
            if [ -f "$file.bak" ]; then
                echo "Fixed file $file"
            fi
        else
            skipping=true
            echo "Skipped file $file"
        fi
    elif [ $file != $fixed_file ]; then
        mv $file "$file.bak"
        ln -s -r firefox-icon-fix.png $file
        if [ -f "$file.bak" ]; then
            echo "Fixed file $file"
        fi
    fi
done

if $skipping; then
    echo ""
    echo "If your firefox version has updated and you want to fix the icons (the icon changes are getting resetted by ever update) use this command with the'--overwrite' flag. Example: $0 --overwrite"
fi
