//
//  PostVideoDelegate.m
//  Starlety
//
//  Created by Luchian Chivoiu on 16/07/2014.
//  Copyright (c) 2014 Luchian Chivoiu. All rights reserved.
//

#import "PostVideoDelegate.h"

@implementation PostVideoDelegate



//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
//{
//	expectedLength = MAX([response expectedContentLength], 1);
//	currentLength = 0;
//    HUD.mode = MBProgressHUDModeDeterminate;
//    
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    NSLog(@"String sent from server %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    
//}
//
//- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
// totalBytesWritten:(NSInteger)totalBytesWritten
//totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
//{
//    HUD.mode = MBProgressHUDModeDeterminate;
//	currentLength = totalBytesWritten;
//	HUD.progress = currentLength / (float)totalBytesExpectedToWrite;
//}
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Images/37x-Checkmark.png"]] autorelease];
//	HUD.mode = MBProgressHUDModeCustomView;
//	[HUD hide:YES afterDelay:2];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Video Uploaded Successfully"
//                                                        message:[NSString stringWithFormat: @"Audition Was Uploaded Successfully and can be seen on the 'NEW STARLETY' Section"]
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];
//    // Append the new data to receivedData.
//    // receivedData is an instance variable declared elsewhere.
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//	[HUD hide:YES];
//}

@end
