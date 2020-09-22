//
//  main.m
//  WhizProject
//
//  Created by Nilesh Dnyaneshwar Raykar on 22/09/20.
//  Copyright © 2020 Nilesh Dnyaneshwar Raykar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
