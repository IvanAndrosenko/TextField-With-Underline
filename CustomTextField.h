//
//  CustomTextField.h
//  Payever
//
//  Created by Ivan Androsenko on 11/4/15.
//  Copyright © 2015 Andros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField
@property (nonatomic, assign) BOOL dropDownTextField;
@property (nonatomic, assign) BOOL withoutUnderLine;

@property (nonatomic, copy) NSString *idData;

@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) UIColor *colorOfText;
@property (nonatomic, assign) CGFloat rightInset;

-(void)resetDropDownTextField;
-(void)updateTextField;
-(void)showTopLabel;
-(void)hideTopLabel;

@end
