# Hello World

## Requirements

In general, you need to install

```cli
sudo pacman -S cmake clang --noconfirm
```

For VS Code specifically, you also need to install

- [CodeLLDB](https://open-vsx.org/extension/vadimcn/vscode-lldb)
- [clangd](https://open-vsx.org/extension/llvm-vs-code-extensions/vscode-clangd)

## Usage

To configure a new build, enter the root directory, and run

```cli
cmake . -B out/debug -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Debug
```

After that, build the application:

```cli
cmake --build out/debug
```

From here on you can use the visual debugger on VS Code to create new builds
by using the short cuts <kbd>ctrl</kbd><kbd>shift</kbd><kbd>B</kbd> followed
by <kbd>F5</kbd>.
