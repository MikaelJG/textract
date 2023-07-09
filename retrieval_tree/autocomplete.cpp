#include <iostream>
#include <vector>
#include <unordered_map> // for retrieval tree
#include <cstdlib>       // for std::system
#include <filesystem>    // for paths
namespace fs = std::filesystem;

struct Node {
    std::unordered_map<char, Node*> child;
    bool isWord;
};

Node* createNode() { // is this a constructor for a node?
    Node* node = new Node;
    node->isWord = false;
    return node;
}

void insertWord(Node* root, const std::string& note_name) {
    Node* curr = root;
    for (char c : note_name) {
        if (curr->child.find(c) == curr->child.end()) {
            curr->child[c] = createNode();
        }
        curr = curr->child[c];
    }
    curr->isWord = true;
}

bool searchPrefix(Node* root, const std::string& requested_filename) {
    Node* curr = root;
    for (char c : requested_filename) {
        if (curr->child.find(c) == curr->child.end()) {
            return false; // Prefix not found
        }
        curr = curr->child[c];
    }
    return true; // Prefix found
}

/////////////////////////////////////////// 

// this find_filename function is a depth-first search!

/////////////////////////////////////////// 

void find_filename(Node* node, const std::string& requested_filename, std::vector<std::string>& results) {
    if (node == nullptr) {
        return;
    }
    
    if (node->isWord) {
        results.push_back(requested_filename);
    }
    
    for (const auto& kv : node->child) {
        find_filename(kv.second, requested_filename + kv.first, results);
    }
}

std::vector<std::string> searchWordsWithPrefix(Node* root, const std::string& requested_filename) {
    std::vector<std::string> results;
    
    Node* curr = root;
    for (char c : requested_filename) {
        if (curr->child.find(c) == curr->child.end()) {
            return results; // Empty results if requested_filename not found
        }
        curr = curr->child[c];
    }
    
    find_filename(curr, requested_filename, results);
    return results;
}

void open_file(const std::string& file_path) {
    std::string command = "nvim " + file_path;
    std::system(command.c_str());
}

int main(int argc, char* argv[]) {

    // save arguments in a vector
    const std::vector<std::string> arguments(argv + 1, argv + argc);

    if (arguments.size() == 0) {
        std::cout << "Please provide an argument." << '\n';
        exit(1);
    } else if (arguments.size() == 2) {
        std::cout << "The program only supports one argument." << '\n';
        exit(1);
    }
    
    // save the argument as a requested .cpp file.
    std::string requested_filename = arguments[0] ;

    Node* root = createNode();

    // save HOME directory
    // ~ is not valid for fs::directory_iterator(path))
    const char* home_dir = std::getenv("HOME");
    const std::string path = std::string(home_dir) + "/code/cpp/examples";
    
    // for all filenames in the given path,
    for (const auto &entry : fs::directory_iterator(path)) {
        std::string note_file = entry.path().filename().string();
    
        // enter the filenames in the retrieval tree
        insertWord(root, note_file);
    }


    std::vector<std::string> note_names = searchWordsWithPrefix(root, requested_filename);
    if (note_names.empty()) {
        std::cout << "No file matches this prefix.\n";
    } else {
        std::cout << "The " << requested_filename + ".cpp" << " file was not found.\n";

        for (const std::string& note_name : note_names) {

            std::string filename = note_name + ".cpp";

            std::string answer;
            std::cout << "Did you mean: " << note_name << "?\n";
            std::cin >> answer;

            if (answer == "yes" || answer == "y") {
                const std::string file_to_open = path + "/" + note_name;

                open_file(file_to_open);
                exit(1);
            } 
        }
    }

    // Cleanup
    // TODO: Implement trie deletion logic to release memory

    return 0;
}


// C++17 // g++ -std=c++17 myfile.cpp -o output-name



