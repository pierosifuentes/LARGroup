//
//  LoginTranslator.m
//  LARGruop
//
//  Created by Piero on 16/09/15.
//  Copyright (c) 2015 prsp.org. All rights reserved.
//

#import "LoginTranslator.h"
#import "User.h"
#import "NSString+Utils.h"

@implementation LoginTranslator

+ (void)userDictionary:(NSDictionary *)userDictionary toUserEntity:(User *)user
{
    id uidObject = [userDictionary valueForKeyPath:@"id"];
    user.uid = ([uidObject isKindOfClass:[NSString class]])? uidObject: ((NSNumber*)uidObject).stringValue;
    
    id fullNameObject = [userDictionary valueForKeyPath:@"name"];
    
    NSArray *components=[fullNameObject componentsSeparatedByString:@" "];
    user.firstName  = components[0];
    user.lastName  = components[1];
    
    id usernameObject = [userDictionary valueForKeyPath:@"username"];
    user.username = ([usernameObject isKindOfClass:[NSString class]])? usernameObject: nil;
    
    id emailObject = [userDictionary valueForKeyPath:@"email"];
    user.email = ([emailObject isKindOfClass:[NSString class]])? emailObject: nil;
    
    id typeObject = [userDictionary valueForKeyPath:@"type"];
    user.type = ([typeObject isKindOfClass:[NSString class]])? typeObject: nil;
    //TODO:THE DATE IS CURRENTLY GETTING NIL, CHECK OUT THIS LATER
    id createdDateObject = [userDictionary valueForKeyPath:@"created_at"];
    NSDate* createdDate = ([createdDateObject isKindOfClass:[NSString class]])?[NSString toDateFromDateString:createdDateObject] : createdDateObject;
    user.created = createdDate;
    
    id updatedDateObject = [userDictionary valueForKeyPath:@"updated_at"];
    NSDate* updateDate = ([updatedDateObject isKindOfClass:[NSString class]])?[NSString toDateFromDateString:updatedDateObject] : updatedDateObject;
    user.lastModified = updateDate;
    
}

+ (void)recipientDictionary:(NSDictionary *)userDictionary toUserEntity:(User *)user
{
    id uidObject = [userDictionary valueForKeyPath:@"id"];
    user.uid = ([uidObject isKindOfClass:[NSNumber class]])? [NSString stringWithFormat:@"%@", uidObject] : nil;
    
//    id fullNameObject = [userDictionary valueForKeyPath:@"full_name"];
//    user.fullName = ([fullNameObject isKindOfClass:[NSString class]])? fullNameObject : nil;
//    
//    id avatarURLObject = [userDictionary valueForKeyPath:@"avatar_url"];
//    user.avatarURL = ([avatarURLObject isKindOfClass:[NSString class]])? avatarURLObject : nil;
}



@end
