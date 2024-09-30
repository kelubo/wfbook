# VI Text Editor[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#vi-text-editor)

In this chapter you will learn how to work with the VIsual editor.

------

**Objectives** : In this chapter, future Linux administrators will learn how to:

![✔](https://twemoji.maxcdn.com/v/latest/svg/2714.svg) Use the main commands of the VI editor; 
 ![✔](https://twemoji.maxcdn.com/v/latest/svg/2714.svg) Modify a text with the VI editor.

![🏁](https://twemoji.maxcdn.com/v/latest/svg/1f3c1.svg) **user commands**, **linux**

**Knowledge**: ![⭐](https://twemoji.maxcdn.com/v/latest/svg/2b50.svg) 
 **Complexity**: ![⭐](https://twemoji.maxcdn.com/v/latest/svg/2b50.svg) ![⭐](https://twemoji.maxcdn.com/v/latest/svg/2b50.svg)

**阅读时间**: 20 分钟

------

*Visual* (**VI**) is a very popular text editor  under Linux, despite its limited ergonomics. It is indeed an editor  entirely in text mode: each action is done with a key on the keyboard or dedicated commands.

Very powerful, it is above all very practical since it is on the  whole minimal for basic applications. It is therefore accessible in case of system failure. Its *universality* (it is present on all Linux distributions and under Unix) makes it a *crucial* tool for the administrator.

Its functionalities are:

- Insert, delete, modify text;
- Copy words, lines or blocks of text;
- Search and replace characters.

## `vi` command[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#vi-command)

The `vi` command opens the *VI* text editor.

```
vi [-c command] [file]
```

Example:

```
$ vi /home/rockstar/file
```

| Option       | Information                                       |
| ------------ | ------------------------------------------------- |
| `-c command` | Execute VI by specifying a command at the opening |

If the file exists at the location mentioned by the path, it is read by VI which is placed in **commands** mode.

If the file does not exist, VI opens a blank file and an empty page  is displayed on the screen. When the file is saved, it will take the  name specified with the command.

If the command `vi` is executed without specifying a file  name, VI opens a blank file and an empty page is displayed on the  screen. When the file is saved, VI will ask for a file name.

The `vim` editor takes the interface and functions of VI with many improvements.

```
vim [-c command] [file]
```

Among these improvements, the user has syntax highlighting, which is  very useful for editing shell scripts or configuration files.

During a session, VI uses a buffer file in which it records all the changes made by the user.

!!! Note As long as the user has not saved his work, the original file is not modified.

At startup, VI is in *commands* mode.

!!! Tip A line of text is ended by pressing ENTER but if the screen is not wide enough, VI makes automatic line breaks, *wrap* configuration by default. These line breaks may not be desired, this is the *nowrap* configuration.

To exit VI, from the Commands mode, tap : then type:

- `q` to exit without saving (*quit*);
- `w` to save your work (*write*);
- `wq` (*write quit*) or `x` (*eXit*) to save and exit.

To force the exit without confirmation, you must add *!* to the previous commands.

!!! Warning There is no periodic backup, so you must remember to save your work regularly.

## Operating mode[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#operating-mode)

In VI, there are 3 working modes:

- The *command* mode;
- The *insertion* mode;
- The *ex* mode.

The philosophy of VI is to alternate between the *command* mode and the *insertion* mode.

The third mode, *ex*, is a footer command mode from an old text editor.

### The Command Mode[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#the-command-mode)

This is the default mode when VI starts up. To access it from any of the other modes, simply press the ESC key.

All entries are interpreted as commands and the corresponding actions are executed. These are essentially commands for editing text (copy,  paste, undo, ...).

The commands are not displayed on the screen.

### The Insert mode[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#the-insert-mode)

This is the text modification mode. To access it from the *command* mode, you have to press special keys that will perform an action in addition to changing the mode.

The text is not entered directly into the file but into a buffer zone in the memory. The changes are only effective when the file is saved.

### The Ex mode[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#the-ex-mode)

This is the file modification mode. To access it, you must first switch to *command* mode, then enter the *ex* command frequently starting with the character `:`.

The command is validated by pressing the ENTER key.

## Moving the cursor[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#moving-the-cursor)

In *command* mode, there are several ways to move the cursor.

The mouse is not active in a text environment but is in a graphic  environment, it is possible to move it character by character, but  shortcuts exist to go faster.

VI remains in *command* mode after moving the cursor.

The cursor is placed under the desired character.

### From a character[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#from-a-character)

- Move one or `n` characters to the left:

←, n←, h or nh

- Move one or `n` characters to the right:

→, n→, l or nl

- Move one or `n` characters up:

↑, n↑, k or nk

- Move one or `n` characters down:

↓, n↓, j or nj

- Move to the end of the line:

$ or END

- Move to the beginning of the line:

0 or POS1

### From the first character of a word[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#from-the-first-character-of-a-word)

Words are made up of letters or numbers. Punctuation characters and apostrophes separate words.

If the cursor is in the middle of a word w moves to the next word, b moves to the beginning of the word.

If the line is finished, VI goes automatically to the next line.

- Move one or `n` words to the right:

w or nw

- Move one or `n` words to the left:

b or nb

### From any location on a line[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#from-any-location-on-a-line)

- Move to last line of text:

G

- Move to line `n`:

nG

- Move to the first line of the screen:

H

- Move to the middle line of the screen:

M

- Move to the last line of the screen:

L

## Inserting text[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#inserting-text)

In *command* mode, there are several ways to insert text.

VI switches to *insert* mode after entering one of these keys.

!!! Note VI switches to *insertion* mode. So you will have to press the ESC key to return to *command* mode.

### In relation to a character[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#in-relation-to-a-character)

- Inserting text before a character:

i (*insert*)

- Inserting text after a character:

a (*append*)

### In relation to a line[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#in-relation-to-a-line)

- Inserting text at the beginning of a line:

I

- Inserting text at the end of a line:

A

### In relation to the text[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#in-relation-to-the-text)

- Inserting text before a line:

O

- Inserting text after a line:

o

## Characters, words and lines[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#characters-words-and-lines)

VI allows text editing by managing:

- characters,
- words,
- lines.

In each case it is possible to :

- delete,
- replace,
- copy,
- cut,
- paste.

These operations are done in *command* mode.

### Characters[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#characters)

- Delete one or `n` characters:

x or nx

- Replace a character with another:

rcharacter

- Replace more than one character with others:

RcharactersESC

!!! Note The R command switches to *replace* mode, which is a kind of *insert* mode.

### Words[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#words)

- Delete (cut) one or `n` words:

dw or ndw

- Copy one or `n` words:

yw or nyw

- Paste a word once or `n` times after the cursor:

p or np

- Paste a word once or `n` times before the cursor:

P or nP

- Replace one word:

cw*word*ESC

!!! Tip It is necessary to position the cursor under the first  character of the word to cut (or copy) otherwise VI will cut (or copy)  only the part of the word between the cursor and the end. To delete a  word is to cut it. If it is not pasted afterwards, the buffer is emptied and the word is deleted.

### Lines[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#lines)

- Delete (cut) one or `n` lines:

dd or ndd

- Copy one or `n` lines:

yy or nyy

- Paste what has been copied or deleted once or `n` times after the current line:

p or np

- Paste what has been copied or deleted once or `n` times before the current line:

P or nP

- Delete (cut) from the beginning of the line to the cursor:

d0

- Delete (cut) from the cursor to the end of the line:

d$

- Copy from the beginning of the line to the cursor:

y0

- Copy from the cursor to the end of the line:

y$

- Delete (cut) the text from the current line:

dL or dG

- Copy the text from the current line:

yL or yG

### Cancel an action[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#cancel-an-action)

- Undo the last action:

u

- Undo the actions on the current line:

U

### Cancel cancellation[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#cancel-cancellation)

- Cancel a cancellation

Ctrl+R

## EX commands[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#ex-commands)

The *Ex* mode allows you to act on the file (saving, layout, options, ...). It is also in *Ex* mode where search and replace commands are entered. The commands are  displayed at the bottom of the page and must be validated with the ENTER key.

To switch to *Ex* mode, from *command* mode, type :.

### Numbering the lines[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#numbering-the-lines)

- Show/hide numbering:

```
:set nu` and the longer `:set number
:set nonu` and the longer `:set nonumber
```

### Search for a string[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#search-for-a-string)

- Search for a string from the cursor:

```
/string
```

- Search for a string before the cursor:

```
?string
```

- Go to the next occurrence found:

n

- Go to the previous occurrence found:

N

There are wildcards to facilitate the search in VI.

- `[]` : Searches for a range of characters or a single character whose possible values are specified.

Example:

`/[Ww]ord` : search *word* and *Word*

`/[1-9]word` : search *1word*, *2word* … *`x`word*  where `x` is a number

- `^` : Search for a string starting the line.

Example:

```
/^Word
```

- `$` : Search for a string ending the line.

Example:

```
/Word$
```

- `.` : Search for a word with an unknown letter.

Example:

`/W.rd` : search *Word*, *Ward* …

- `*` : Search for one or more characters, whatever they are.

Example:

```
/W*d
```

### Replace a string[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#replace-a-string)

From the 1st to the last line of the text, replace the searched string by the specified string:

```
:1,$ s/search/replace
```

**Note:** You can also use `:0,$s/search/replace` to specify starting at the absolute beginning of the file.

From line `n` to line `m`, replace the searched string with the specified string:

```
:n,m s/search/replace
```

By default, only the first occurrence found of each line is replaced. To force the replacement of each occurrence, you have to add `/g` at the end of the command:

```
:n,m s/search/replace/g
```

Browse an entire file to replace the searched string with the specified string:

```
:% s/search/replace
```

### File operations[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#file-operations)

- Save the file:

```
:w
```

- Save under another name:

```
:w file
```

- Save from line `n` to line `m` in another file:

```
:n,m w file
```

- Reload the last record of the file:

```
e!
```

- Paste the content of another file after the cursor:

```
:r file
```

- Quit editing a file without saving:

```
:q
```

- Quit editing a file that has been modified during the session but not saved:

```
:q!
```

- Exit the file and save:

```
:wq` or `:x
```

## Other functions[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#other-functions)

It is possible to execute VI by specifying the options to be loaded for the session. To do this, you must use the `-c` option:

```
$ vi -c "set nu" /home/rockstar/file
```

It is also possible to enter the *Ex* commands in a file named `.exrc` put in the user's login directory. At each VI or VIM startup, the commands will be read and applied.

### `vimtutor` command[¶](https://docs.rockylinux.org/zh/books/admin_guide/05-vi/#vimtutor-command)

There is a tutorial for learning how to use VI. It is accessible with the command `vimtutor`.

```
$ vimtutor
```