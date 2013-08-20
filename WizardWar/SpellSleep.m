//
//  SpellSleep.m
//  WizardWar
//
//  Created by Sean Hess on 6/13/13.
//  Copyright (c) 2013 The LAB. All rights reserved.
//

#import "SpellSleep.h"
#import "SpellMonster.h"
#import "SpellIcewall.h"
#import "EffectSleep.h"
#import "SpellBubble.h"

@implementation SpellSleep

-(id)init {
    if ((self=[super init])) {
        self.damage = 0;
        self.heavy = NO;
        self.name = @"Sleep";        
    }
    return self;
}

-(PlayerEffect*)effect {
    return [EffectSleep new];
}

-(SpellInteraction *)interactSpell:(Spell *)spell currentTick:(NSInteger)currentTick {
    
    if ([spell isType:[SpellBubble class]]) {
        if (self.position == spell.position && self.speed == spell.speed && self.direction == spell.direction)
            return [SpellInteraction nothing];
        
        self.linkedSpell = spell;
        self.position = spell.position;
        self.speed = spell.speed;
        self.direction = spell.direction;
        return [SpellInteraction modify];
    }
    
    // the order matters, because the effect gets applied RIGHT THEN
    else if ([spell isType:[SpellMonster class]]) {
        if([spell.effect isKindOfClass:[EffectSleep class]] && spell.effect.startTick < currentTick)
            return [SpellInteraction nothing];
        return [SpellInteraction cancel];
    }
    
    // Does not react while in a bubble
    else if ([self.linkedSpell isKindOfClass:[SpellBubble class]]) {
        return [SpellInteraction nothing];
    }    
    
    else if ([spell isType:[SpellIcewall class]] && spell.direction != self.direction) {
        return [SpellInteraction cancel];
    }
    
    return [SpellInteraction nothing];
}

@end
