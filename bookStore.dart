import "dart:io";

class BookStore {
  static Map map = {};
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

    /* Each time we make a new object , it's attributes will be stored in this map with 
    a unique keys to prevent duplicates */

    if (!map.containsKey(this._bookName)) {
      map[this._bookName] = [this._bookAuthor, this._bookRate];
      print('${this._bookName} has been added successfully');
    } else {
      print('Books names should be unique');
    }
    // Map sample
    // {
    //  book1.name : [book1.author , book1.rate] ,
    //  book2.name : [book2.author , book2.rate]
    // }
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
    reprOutput(map);
  }

  static void addBook() {
    late int count;
    stdout.write("Enter the count of books want to add : ");
    try {
      count = int.parse(stdin.readLineSync()!);
    } on FormatException {
      print('value should be a valid number');
      return;
    }
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

        if ([name, author, rate].every((val) => !val.isEmpty)) {
          BookStore new_book = BookStore(
              bookName: name, bookAuthor: author, bookRate: double.parse(rate));
        } else {
          print('Adding proccess failed because of some empty values...');
          break;
        }
      } on Exception {
        print('Something went wrong,Please try again...');
        break;
      }
      i++;
    }
  }

  static void displayBooksWithHigherRate() {
    Map filtered = Map.fromIterable(map.keys.where((k) => map[k][1] >= 4),
        key: (k) => k, value: (k) => map[k]);

    reprOutput(filtered);
  }

  static void deleteBook() {
    stdout.write("Enter book name to delete : ");
    String toDelete = stdin.readLineSync()!;
    if (!toDelete.isEmpty) {
      if (map.containsKey(toDelete)) {
        map.remove(toDelete);
        print('${toDelete} has been deleted');
      } else {
        print('No such book named ${toDelete},please try again...');
      }
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

      if (map.containsKey(old_name)) {
        if ([new_name, new_author, new_rate].every((val) => !val.isEmpty)) {
          map.remove(old_name);
          map[new_name] = [new_author, new_rate];
        } else {
          print('Updating proccess failed becauese of some empty values...');
        }
      } else {
        print('No such book named ${old_name},please try again...');
      }
    } on Exception {
      print('Something went wrong,Please try again...');
    }
  }

  static void searchBook() {
    stdout.write("Enter a query : ");
    try {
      String toFind = stdin.readLineSync()!;

      Map query = Map.fromIterable(
          map.keys.where((k) => k.toString().contains(toFind)),
          key: (k) => k,
          value: (k) => map[k]);

      reprOutput(query);
    } on Exception {
      print('Something went wrong,Please try again...');
    }
  }

  //  ------------------ helper method ------------------
  static void reprOutput(Map map) {
    print('\nBook name\t Book author \t\trate\n${'-' * 50}\n');
    (!map.isEmpty)
        ? map.forEach((k, v) => print("$k \t\t    ${v[0]} \t\t\t    ${v[1]}"))
        : print('There is no books!');
  }
}
