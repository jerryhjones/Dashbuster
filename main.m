#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ibboApp.h"

#include <stdio.h>

#include <CoreFoundation/CoreFoundation.h>

int main(int argc, char **argv)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    return UIApplicationMain(argc, argv, [ibboApp class]);
}
