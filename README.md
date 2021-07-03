# Hello World

## Recommended Reading

Resources created by members of the [`cpp-gamedev`](https://github.com/cpp-gamedev)
organization:

- <https://cpp-gamedev.netlify.app/tags/101/>
- <https://www.hentai-chan.dev/blog/cpp-build-process>

## Requirements

In general, you need to install

```cli
sudo pacman -S cmake clang --noconfirm
```

For VS Code specifically, you also need to install

- [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb)
- [clangd](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd)
- [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)

## Dev Notes

To configure a new build, enter the root directory, and run

```cli
cmake . -B out/debug -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

After that, build the application:

```cli
cmake --build out/debug
```

From here on you can use the visual debugger on VS Code to create new builds
by using the short cuts <kbd>ctrl</kbd><kbd>shift</kbd><kbd>B</kbd> followed
by <kbd>F5</kbd>.

## Clang

This project uses the LLVM style for `clang-format`:

```cli
clang-format --style=llvm -dump-config > .clang-format
```

See the [docs](https://clang.llvm.org/extra/clang-tidy/) for all options. Run
`clang-tidy -list-checks` in the command line to list all enabled checks.

```cli
clang-tidy ./src/*.[ch]pp -dump-config -checks='clang-analyzer-*,modernize-*,performance-*,readability-*' > .clang-tidy
```

Run `clang-tidy`. Add the `-fix` option to automatically apply suggested fixes.

```cli
python run-clang-tidy.py -config='' -p ./out/debug -header-filter='.*' ./src/*.?pp
```

## CI Configuration

Go to <https://ci.appveyor.com/> add grant access to your repository. Rename the
executable in line 20 from `out/hello.sln` to your executable as defined in
`CMakeLists.txt`.
