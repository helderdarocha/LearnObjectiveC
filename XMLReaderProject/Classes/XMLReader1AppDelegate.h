//
//  XMLReader1AppDelegate.h
//  XMLReader1
//
//  Created by Helder da Rocha on 15/02/2011.
//  Copyright 2011 Argo Navis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMLReader1AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

