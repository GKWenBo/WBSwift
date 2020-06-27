//
//  main.m
//  编译器
//
//  Created by WENBO on 2020/6/23.
//  Copyright © 2020 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define DEFINEEIGHT 8

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        
        int eight = DEFINEEIGHT;
        
        int six = 6;
        NSString *site = [NSString stringWithUTF8String:"starming"];
        int rank = eight + six;
        NSLog(@"%@ rank %d", site, rank);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

// MARK: - 命令
/*
 
 
 /// 查看编译源文件几个阶段
 clang -ccc-print-phases main.m
 
 /// 查看Objective-C的C语言实现
 clang -rewrite-objc main.m
 
 /// 1、预处理完成后，clang就会进行词法分析。将代码切成一个一个token
 clang -fmodules -fsyntax-only -Xclang -dump-tokens main.m
 
 /// 2、进行语法分析，验证语法是否正确
 clang -fmodules -fsyntax-only -Xclang -ast-dump main.m
 
 /// 3、IR代码生成
 clang -S -fobjc-arc -emit-llvm main.m -o main.ll
 
 /// 4、优化工作
 clang -O3 -S -fobjc-arc -emit-llvm main.m -o main.ll
 
 /// 开启Bitcode
 clang -emit-llvm -c main.m -o main.bc
 
 /// 生成汇编
 clang -S -fobjc-arc main.m -o main.s
 
 /// 生成目标文件
 clang -fmodules -c main.m -o main.o
 
 */
