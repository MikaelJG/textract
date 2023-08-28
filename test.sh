AUTO=true ./textract.sh example.tex cpp
AUTO=true ./textract.sh example.tex cpp testing

# TODO: Add a test below that checks the content of files and links, to make
# sure we get the expected output

echo "Test successful!"

# Clean up
rm -r output testing
echo "Successfully cleaned up test."
