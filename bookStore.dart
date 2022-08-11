import "dart:io";

class BookStore {
  static List allBooks = [];
  late String _bookName;
  late String _bookAuthor;
  late double _bookRate;

  BookStore(
      {required String bookName,
      required String bookAuthor,
      required double bookRate}) {
    this._bookName = bookName;
    this._bookAuthor = bookAuthor;
    this._bookRate = bookRate;

    allBooks.add([this._bookName, this._bookAuthor, this._bookRate]);
  }
  //---------- Getters ---------------
  String get bookName {
    return this._bookName;
  }

  String get bookAuthor {
    return this._bookAuthor;
  }

  double get bookRate {
    return this._bookRate;
  }

  static void start() {
    /* the method that is called when the program is
     run. It displays the main menu and calls the appropriate 
     method based on the user's choice.*/
    print('\nWelcome to our book store management system 📚');
    late int choice;
    while (true) {
      try {
        choice = displayMainMenu();
        if (choice == 7) {
          stdout.write('Are you sure you want to quit? Y/N\n');
          String choice2 = stdin.readLineSync()!;
          if (choice2 == 'Y'.trim() || choice2 == 'y'.trim()) {
            print('Goodbye 👋');
            break;
          }
        }
      } on FormatException {
        print('value should be a valid number');
      }
      switch (choice) {
        case 1:
          displayAllBooks();
          break;
        case 2:
          displayBooksWithHigherRate();
          break;
        case 3:
          addBook();
          break;
        case 4:
          updateBook();
          break;
        case 5:
          deleteBook();
          break;
        case 6:
          searchBook();
          break;
        case 7:
          break;
        default:
          print('Out of range input');
      }
    }
  }

  static int displayMainMenu() {
    print('''\nMain menu 
    1- Display all books 
    2- Display books with rate +4.
    3- Add book
    4- Update book
    5- Delete book
    6- Search
    7- quit''');
    stdout.write("\nWrite your choice : ");
    int choice = (int.parse(stdin.readLineSync()!));
    return choice;
  }

  static void displayAllBooks() {
    if (!isEmpty(allBooks)) {
      reprOutput(allBooks);
    }
  }

  static void addBook() {
    stdout.write("Enter the count of books want to add : ");
    int count = int.parse(stdin.readLineSync()!);
    int i = 1;
    while (i <= count) {
      try {
        stdout.write("Enter book name : ");
        String name = stdin.readLineSync()!;
        stdout.write("Enter book author : ");
        String author = stdin.readLineSync()!;

        stdout.write("Enter book rate : ");
        String rate = stdin.readLineSync()!;
        print('=' * 50);

        BookStore new_book = BookStore(
            bookName: name, bookAuthor: author, bookRate: double.parse(rate));
        print('${name} has been added successfully');
      } on Exception {
        print('Something went wrong,Please try again...');
      }
      i++;
    }
  }

  static void displayBooksWithHigherRate() {
    Iterable filtered =
        BookStore.allBooks.where((eachBook) => eachBook[2] >= 4);
    if (!isEmpty(filtered)) {
      reprOutput(filtered);
    }
  }

  static void deleteBook() {
    stdout.write("Enter book name to delete : ");
    String name = stdin.readLineSync()!;
    if (check_and_remove(name)) {
      print('book has been deleted');
    }
  }

  static void updateBook() {
    try {
      stdout.write("Enter book name to update : ");
      String old_name = stdin.readLineSync()!;

      stdout.write("Enter new book name : ");
      String new_name = stdin.readLineSync()!;

      stdout.write("Enter new author name : ");
      String new_author = stdin.readLineSync()!;

      stdout.write("Enter new book rate : ");
      String new_rate = stdin.readLineSync()!;

      if (check_and_remove(old_name)) {
        BookStore updated = BookStore(
            bookName: new_name,
            bookAuthor: new_author,
            bookRate: double.parse(new_rate));
        print('${old_name} has been updated successfully');
      }
    } on Exception {
      print('Something went wrong,Please try again...');
    }
  }

  static void searchBook() {
    stdout.write("Enter a query : ");
    try {
      String toFind = stdin.readLineSync()!;
      Iterable filtered =
          BookStore.allBooks.where((eachBook) => eachBook[0].contains(toFind));
      if (!isEmpty(filtered)) {
        reprOutput(filtered);
      }
    } on Exception {
      print('Something went wrong,Please try again...');
    }
  }

  //  ------------------ helper methods ------------------
  static void reprOutput(Iterable toShow) {
    print('\nBook name\t Book author \t\trate\n${'-' * 50}\n');
    for (List i in toShow) {
      for (var j in i) {
        stdout.write(j);
        stdout.write('\t\t ');
      }
      print('');
    }
  }

  static bool isEmpty(Iterable toCheck) {
    if (toCheck.length == 0) {
      print('\nThere is no Books!');
      return true;
    }
    return false;
  }

  static bool check_and_remove(String name) {
    int new_length = allBooks.length;
    BookStore.allBooks.removeWhere((eachBook) => eachBook[0] == name);
    if (new_length != allBooks.length) {
      return true;
    } else {
      print('No such book named ${name},please try again...');
      return false;
    }
  }
}
