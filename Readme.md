clang -fmodules -c NSObject+MyCategory.m -o link.o
nm link.o   // 从 .m 生成 .o
clang -fmodules -c main.m -o main.o
nm main.o   // 从 .m 生成 .o
ar rcs link.a link.o   // 将 .o 生成静态库 .a
clang main.o link.a -framework Foundation -whyload  // 链接 main.o 与 link.a
./a.out
clang main.o link.a -framework Foundation -whyload -ObjC  // 链接 main.o 与 link.a，强制加载 cateogry 方法
./a.out
