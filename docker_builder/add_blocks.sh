read -p "add tag to your block" tag
while true;
do
	if [[ grep -p "{${tag}" blocks.txt ]];
	then
		echo "the blocks.txt have contains a block tagged $tag."
		read -p "enter again" tag
	fi
done

echo "" >> blocks.txt
echo "{$tag" >> blocks.txt

while true;
do
	echo "enter commands and stop by crtl + D (need to indent by yourself):"
	commands=$(cat)
	echo "-------------------------------------------------"
	echo "$commands"
	echo "-------------------------------------------------"
	read -p "save it to blocks.txt?(y|N)" save
	if [[ save == 'y' ]];
	then
		echo "$commands" >> blocks.txt
		break
	else
		head -n -2 blocks.txt > temp_file && mv temp_file blocks.txt
		exit 0
	fi
done

echo "}$tag" >> blocks.txt
echo "" >> blocks.txt
