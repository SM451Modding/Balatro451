--- STEAMODDED HEADER
--- MOD_NAME: Balatro451
--- MOD_ID: Balatro451
--- MOD_AUTHOR: [SM451]
--- MOD_DESCRIPTION: Mod by SM451
--- LOADER_VERSION_GEQ: 1.0.0
--- BADGE_COLOR: 57bf47


----------------------------------------------
------------MOD CODE -------------------------


SMODS.Atlas{
    key = "jokers451",
    path = "jokers451.png",
    px = 71,
    py = 95
}

-- COMMON JOKERS

SMODS.Joker{
  key = 'pointillism',
  loc_txt = {name = 'Pointillism Joker', text = {"Each played {C:attention}Ace{}", "gives {C:mult}+#1#{} Mult when scored", "{C:inactive}'All part of a bigger picture'{C:inactive}"}},
  config = {extra = {mult = 8}},
  rarity = 1, cost = 4, blueprint_compat = true, discovered = true,
  atlas = 'jokers451', pos = {x = 0, y = 0},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card:get_id() == 14 then
        return {
          mult = card.ability.extra.mult,
          card = card,
          colour = G.C.RED,
          message = "+#1#"
        }
      end
    end
  end
}

SMODS.Joker{
  key = 'timecard',
  loc_txt = {
    name = 'Time Card', text = {"Each played {C:attention}9{} or {C:attention}5", "gives {C:chips}+#1#{} Chips and", "{C:mult}+#2#{} Mult when scored", "{C:inactive}'What a way to make a livin'{C:inactive}"}},
  config = {extra = {chips = 10, mult = 4}},
  rarity = 1, cost = 4, discovered = true,
  atlas = 'jokers451', pos = {x = 3, y = 0},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips, card.ability.extra.mult}}
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card:get_id() == 9 or context.other_card:get_id() == 5 then
        return {
          chips = card.ability.extra.chips,
          mult = card.ability.extra.mult,
          card = card
        }
      end
    end
  end
}

SMODS.Joker{
  key = 'jpod',
  loc_txt = {
    name = 'JPod Shuffle', text = {"This Joker gains {C:chips}+#2#{} Chips", "when any {C:attention}Booster Pack{} is skipped", "{C:inactive}(Currently{C:inactive} {C:chips}+#1#{} {C:inactive}Chips){C:inactive}", "{C:inactive}'Life is random'{C:inactive}"}},
  config = {extra = {chips = 0, chip_gain = 25}},
  rarity = 1, cost = 5, discovered = true,
  atlas = 'jokers451', pos = {x = 4, y = 0},
  loc_vars = function(self, info_queue, card)
   return {vars = {card.ability.extra.chips, card.ability.extra.chip_gain}}
  end,
  calculate = function(self, card, context)
   if context.joker_main then
    return {
     chip_mod = card.ability.extra.chips,
     message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
    }
   end
   if context.skipping_booster then
    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
    return {
     card = card,
     message = 'Upgraded!',
     colour = G.C.CHIPS
    }
   end
  end
}

-- UNCOMMON JOKERS

SMODS.Joker{
  key = 'rorschach',
  loc_txt = {
    name = 'Rorschach Joker', text = {"Retrigger all played cards.", "{C:green}#1# in #2#{} chance this card is", "destroyed at end of round", "{C:inactive}'Look closer, what do you see?'{C:inactive}"}},
  rarity = 2, cost = 6, eternal_compat = false, discovered = true,
  atlas = 'jokers451', pos = {x = 2, y = 0},
  config = {extra = {repetitions = 1, odds = 10}},
   yes_pool_flag = 'rorschach_extinct', 
  loc_vars = function(self, info_queue, card)
    return {vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds}}
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then
      return {
        message = 'Again!',
        repetitions = card.ability.extra.repetitions,
        card = context.other_card
      }
    end
    if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint then
      if pseudorandom('rorschach') < G.GAME.probabilities.normal/card.ability.extra.odds then
        G.E_MANAGER:add_event(Event({
              func = function()
                play_sound('tarot1')
                card.T.r = -0.2
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                      func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true; end})) 
                  return true
                end
              }))
        return {
         message = 'Extinct!'
        }
      else
       return {
           message = 'Safe!'
       }
       end
    end
  end
}

-- RARE JOKERS

SMODS.Joker{
  key = 'eclipse',
  loc_txt = {name = 'Eclipse Joker', text = {"{X:mult,C:white} X#1# {} Mult. {C:red}#2#{} hand size", "{C:inactive}'Let light shine out of darkness'{C:inactive}"}},
  config = {extra = {Xmult = 5, h_size = -3}},
  rarity = 3, cost = 8, blueprint_compat = true, discovered = true,
  atlas = 'jokers451', pos = {x = 1, y = 0},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult, card.ability.extra.h_size}}
  end,
  add_to_deck = function(self, card, from_debuff)
   G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
   G.hand:change_size(-card.ability.extra.h_size)
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        card = card,
        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
        Xmult_mod = card.ability.extra.Xmult
      }
    end
  end
}
----------------------------------------------
------------MOD CODE END----------------------
