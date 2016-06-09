//
//  CustomTextField.m
//  Payever
//
//  Created by Ivan Androsenko on 11/4/15.
//  Copyright © 2015 Andros. All rights reserved.
//

#import "CustomTextField.h"

@interface CustomTextField () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *underLine;
@property (nonatomic, strong) UILabel *labelPlaceholder;
@property (nonatomic, weak) id <UITextFieldDelegate> prevDelegate;
@property (assign) CGFloat heightOfPlaceholderFont;

@end

@implementation CustomTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _heightOfPlaceholderFont = 10;
    if (!IPAD) {
        if (SCREEN_WIDTH == 375) {
            _heightOfPlaceholderFont = 11.5;
        }
        if (SCREEN_WIDTH > 375) {
            _heightOfPlaceholderFont = 14;
        }
    }else
        _heightOfPlaceholderFont = 12;


    if (!_withoutUnderLine) {
        _underLine = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height - 2, rect.size.width, 1.5)];
        [self addSubview:_underLine];
    }
    
    [self updateTextField];

    
    _labelPlaceholder = [[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height/2 + 4, rect.size.width, _heightOfPlaceholderFont + 2)];
    _labelPlaceholder.textColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    _labelPlaceholder.text = self.placeholder;
    _labelPlaceholder.font = self.font;
    _labelPlaceholder.textAlignment = self.textAlignment;
    [self addSubview:_labelPlaceholder];
    _labelPlaceholder.alpha = 0.0f;
    _labelPlaceholder.adjustsFontSizeToFitWidth=YES;
    _labelPlaceholder.minimumScaleFactor = 0.5;

    [super drawRect:rect];
    
  //  NSLog(@"%@", self.delegate);
  //  NSLog(@"class %@", [self.delegate class]);

    self.prevDelegate = self.delegate;
    if (!self.delegate)
    {
        self.delegate = self;
    }
    
    if (self.text.length > 0) {
        [self showTopLabel];
    }else
    {
        [self hideTopLabel];
    }
    
    [self addTarget:self action:@selector(didEndEditing) forControlEvents:UIControlEventEditingDidEnd];
}

-(void)didEndEditing
{
    [self layoutIfNeeded];
    [self resetDropDownTextField];
}

-(void)showTopLabel
{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         _labelPlaceholder.textColor = [UIColor colorWithRed:0.0f/255.0f green:132.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
                         _labelPlaceholder.frame = CGRectMake(0, -1, self.frame.size.width, _heightOfPlaceholderFont + 2);
                         _labelPlaceholder.alpha = 1.0f;
                         _labelPlaceholder.font = [self.font fontWithSize:_heightOfPlaceholderFont];

                     } completion:NULL];
}

-(void)hideTopLabel
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         _labelPlaceholder.textColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
                         _labelPlaceholder.alpha = 0.0f;
                         _labelPlaceholder.frame = CGRectMake(0, self.frame.size.height/2 + 4, self.frame.size.width, _heightOfPlaceholderFont + 2);
                         _labelPlaceholder.font = [self.font fontWithSize:16];


                     } completion:^(BOOL finished) {
                         if (finished) {
                             _labelPlaceholder.font = self.font;
                         }
                     }];

}

-(BOOL)becomeFirstResponder
{
    BOOL returnValue = [super becomeFirstResponder];

    if (returnValue) {
        _underLine.frame = CGRectMake(0, self.frame.size.height - 2.5, self.frame.size.width, 2);
        _underLine.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:132.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    }
    
    if (_dropDownTextField) {
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowDropup"]];
        [icon setFrame:CGRectMake(0.0f, 0.0f, 7.0f, 7.5f)];
        self.rightView = icon;
        _underLine.frame = CGRectMake(0, self.frame.size.height - 2.5, self.frame.size.width, 2);
        _underLine.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:132.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    }
    
    return returnValue;
}

-(BOOL)resignFirstResponder
{
    BOOL returnValue = [super resignFirstResponder];

    if (returnValue) {
        _underLine.frame = CGRectMake(0, self.frame.size.height - 2.0, self.frame.size.width, 1.5);
       // _underLine.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    }
    
    if (_dropDownTextField) {
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowDropdown"]];
        [icon setFrame:CGRectMake(0.0f, 0.0f, 7.0f, 7.5f)];
        self.rightView = icon;
    }
    [self updateTextField];

    return returnValue;
}

-(void)setDropDownTextField:(BOOL)dropDown
{
    if (dropDown) {
        self.rightViewMode = UITextFieldViewModeAlways;
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowDropdown"]];
         [icon setFrame:CGRectMake(0.0f, 0.0f, 7.0f, 7.5f)];
         self.rightView = icon;
    }else
        self.rightViewMode = UITextFieldViewModeNever;

    _dropDownTextField = dropDown;
}

-(void)resetDropDownTextField
{
    UIImageView *icon = (UIImageView *)self.rightView;
    if (icon) {
        icon.image = [UIImage imageNamed:@"arrowDropdown"];
        self.rightView = icon;
    }
    
    _underLine.frame = CGRectMake(0, self.frame.size.height - 2.0, self.frame.size.width, 1.5);
    //_underLine.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    [self updateTextField];
}

-(void)updateTextField
{
    _labelPlaceholder.text = self.placeholder;
    if (_error) {
        _underLine.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:5.0f/255.0f blue:23.0f/255.0f alpha:1.0f];
    }else
        _underLine.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    if (self.text.length > 0) {

        _labelPlaceholder.textColor = [UIColor colorWithRed:0.0f/255.0f green:132.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        _labelPlaceholder.frame = CGRectMake(0, -1, self.frame.size.width, _heightOfPlaceholderFont + 1);
        _labelPlaceholder.alpha = 1.0f;
        _labelPlaceholder.font = [self.font fontWithSize:_heightOfPlaceholderFont];
    }else
    {
        _labelPlaceholder.textColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
        _labelPlaceholder.alpha = 0.0f;
        _labelPlaceholder.frame = CGRectMake(0, self.frame.size.height/2 + 4, self.frame.size.width, _heightOfPlaceholderFont + 2);
        _labelPlaceholder.font = [self.font fontWithSize:_heightOfPlaceholderFont * 1.5];
    }

}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.prevDelegate && [self.prevDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.prevDelegate textFieldDidBeginEditing:textField];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.prevDelegate && [self.prevDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.prevDelegate textFieldDidEndEditing:textField];
    }
    [textField layoutIfNeeded];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.prevDelegate && [self.prevDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.prevDelegate textFieldShouldBeginEditing:textField];
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.prevDelegate && [self.prevDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.prevDelegate textFieldShouldEndEditing:textField];
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.prevDelegate && [self.prevDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.prevDelegate textFieldShouldReturn:textField];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.prevDelegate && [self.prevDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        [self.prevDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    if (!self.prevDelegate) {
        if ([string isEqualToString:@"\n"])
        {
            [textField resignFirstResponder];
            return NO;
        }
    }
    NSString *strToCheck;
    if (!self.prevDelegate) {
        NSMutableString *strSearch = [NSMutableString stringWithFormat:@"%@", textField.text];
        if ([string isEqualToString:@""])
        {   if(strSearch.length > 0)
            [strSearch deleteCharactersInRange:NSMakeRange([strSearch length]-1, 1)];
        }else
        {
            [strSearch appendString:string];
        }
        strToCheck = strSearch;
    }else
    {
        strToCheck = textField.text;
    }
    
    if (strToCheck.length > 0) {
        [self showTopLabel];
    }else
    {
        [self hideTopLabel];
    }
    if (self.prevDelegate) {
        return NO;
    }else
        return YES;
    
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect newBounds = bounds;
    newBounds.origin.y = 2;
    if (!IPAD) {
        if (SCREEN_WIDTH == 375) {
            newBounds.origin.y = 3;
        }
        if (SCREEN_WIDTH > 375) {
            newBounds.origin.y = 4;
        }
    }
    newBounds.size.width -= _rightInset;

    return CGRectInset(newBounds, 0, 0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect newBounds = bounds;
    newBounds.origin.y = 2;
    if (!IPAD) {
        if (SCREEN_WIDTH == 375) {
            newBounds.origin.y = 3;
        }
        if (SCREEN_WIDTH > 375) {
            newBounds.origin.y = 4;
        }
    }
    newBounds.size.width -= _rightInset;

    return CGRectInset(newBounds, 0, 0);
}


@end
