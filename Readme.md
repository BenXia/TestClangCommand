
#命令行常用的

clang -fmodules -c NSObject+MyCategory.m -o link.o  // 从 .m 生成 .o
nm link.o   
clang -fmodules -c main.m -o main.o  // 从 .m 生成 .o
nm main.o              // nm命令被用于显示二进制目标文件的符号表
ar rcs link.a link.o   // 将 .o 生成静态库 .a
clang main.o link.a -framework Foundation -whyload  // 链接 main.o 与 link.a
./a.out
clang main.o link.a -framework Foundation -whyload -ObjC  // 链接 main.o 与 link.a，强制加载 cateogry 方法
./a.out

可以将含有Block语法的源代码变化为C++的源代码：
clang -rewrite-objc 源代码文件名 目标文件名(可以省略)

otool -L a.out  // -L 参数打印出所有 link 的 framework（去掉了版本信息如下）

lipo -info xxxxx.a  // 查看支持构架的命令
lipo -create xxxx_iphoneos.a xxxx_simulator.a -output xxxx.a  // 合并真机和模拟器的库的命令

1. **Preprocess - 预处理**
- import头文件
- macro 展开
- 处理'#'打头的预处理指令，如 #if

> clang -E main.m  
> // pch 可以优化这个过程，但不要把自己的一些全局变量和相关东西放pch中

> clang -E -fmodules main.m
> // 新版Xcode已经支持fmodules参数，一些系统库会优化这个过程 展开成了@import Foundation

2. **Lexical Analysis - 词法分析**
- 词法分析，也作 Lex 或者 Tokenization
- 将预处理过的代码文本转化为Token流
- 不校验语义

> clang -fmodules -fsyntax-only -Xclang -dump-tokens main.m

3. **Semantic Analysic - 语法分析**

- 语法分析，在 Clang 中由 Parser 和 Sema 两个模块配合完成
- 验证语法是否正确
- 根据当前语言的语法，生成语意节点，并将所有节点组合成抽象语法树（AST）

> clang -fmodules -fsyntax-only -Xclang -ast-dump main.m

4. **Static Analysis - 静态分析**
- 通过语法树进行代码静态分析，找出非语法性错误
- 模拟代码执行路径，分析出 control-flow graph (CFG)
- 预置了常用 Checker

5. **CodeGen - IR 代码生成**
- CodeGen 负责将语法树自顶至下遍历，翻译成LLVM IR
- LLVM IR 是 Frontend 的输出，也是LLVM Backend 的输入，前后端的桥接语言
- 与 Objective-C Runtime 桥接
> Class / Meta Class / Protocol / Category 内存结构生成，并存放在指定 section 中（如 Class: _DATA, _objc_classrefs)  
> Method / Ivar / Property 内存结构生成
> 组成 method_list / ivar_list / property_list 并填入 Class
> Non-Fragile ABI: 为每个Ivar合成 OBJC_IVAR_$_ 偏移值常量
> 存取 Ivar 的语句（_ivar = 123; int a = _ivar;) 转写成 base + OBJC_IVAR_$_ 的形式

- 将语法树中的 ObjCMessageExpr 翻译成对应版本的 objc_msgSend，对 super 关键字的调用翻译成 objc_msgSendSuper
- 根据修饰符 strong / weak / copy / atomic 合成 @property 自动实现的 setter / getter
- 处理 @synthesize
- 生成 block_layout 的数据结构
- 变量的 capture（__block / __weak)
- 生成 _block_invoke 函数
- ARC：分析对象引用关系，将 objc_storeStrong / objc_storeWeak 等 ARC 代码插入
- 将 ObjCAutoreleasePoolStmt 转译成 objc_autoreleasePoolPush/Pop
- 实现自动调用 [super dealloc]
- 为每个拥有 ivar 的 Class 合成 .cxx_destructor 方法来自动释放类的成员变量，代替 MRC 时代的 "self.xxx = nil"

> clang -S -fobjc-arc -emit-llvm main.m -o main.ll  
> //-S 表示到编译到汇编层面  
> //-emit-llvm表示编译到IR

6. **Optimize - 优化 IR**
> clang -O3 -S -fobjc-arc -emit-llvm main.m -o main.ll
> // 编译器发展中最难的步骤

7. **LLVM Bitcode - 生成字节码**
> clang -emit-llvm -c main.m -o main.bc

8. **Assemble - 生成 Target 相关汇编**
> clang -S -fobjc-arc main.m -o main.s

9. **Assemble - 生成 Target 相关 Object(Mach-O)**
> clang -fmodules -c main.m -o main.o

10. **Link 生成 Executable**
> clang main.m -o main  
> // 生成的 main 已经是可执行文件

#下面是lldb常用的
exp ***.backgroundColor = [UIColor redColor]
dis 反汇编  //  -fm
p/t 二进制方式打印值  // p/d p/x p/o
print (IMP)0x96a1a550
