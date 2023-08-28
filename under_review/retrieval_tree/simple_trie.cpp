#include <iostream>
#include <unordered_map>

class Node {
public:
    bool isWord;
    std::unordered_map<char, Node*> child;

    Node() : isWord(false) {} // this is the constructor
};

class Trie {
private:
    Node* root;

public:
    Trie() {
        root = new Node();
    }

    void insert(const std::string& note_filename) {
        Node* curr = root;
        for (char letter : note_filename) {
            if (curr->child.find(letter) == curr->child.end()) {
                curr->child[letter] = new Node();
            }
            curr = curr->child[letter];
        }
        curr->isWord = true;
    }

    bool search(const std::string& note_filename) {
        Node* curr = root;
        for (char letter : note_filename) {
            if (curr->child.find(letter) == curr->child.end()) {
                return false;
            }
            curr = curr->child[letter];
        }
        return curr->isWord;
    }
};

int main() {
    Trie notes_filename_tree;
    
    // Insert words into the notes_filename_tree
    
    // Insert all the files here.
    
    notes_filename_tree.insert("apple");
    notes_filename_tree.insert("banana");
    notes_filename_tree.insert("cat");
    
    // Search for words in the notes_filename_tree
    std::cout << notes_filename_tree.search("apple") << std::endl;  // Output: 1 (true)
    std::cout << notes_filename_tree.search("banana") << std::endl; // Output: 1 (true)
    std::cout << notes_filename_tree.search("cat") << std::endl;    // Output: 1 (true)
    std::cout << notes_filename_tree.search("car") << std::endl;    // Output: 0 (false)

    return 0;
}

