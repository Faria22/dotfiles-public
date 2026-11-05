/*
Copyright 2019 @foostan
Copyright 2020 Drashna Jaelre <@drashna>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include QMK_KEYBOARD_H

#define XX KC_NO
#define __ KC_TRNS

#define HRM_LCTL LGUI_T(KC_A)
#define HRM_LALT LALT_T(KC_R)
#define HRM_LSFT LSFT_T(KC_S)
#define HRM_LGUI LCTL_T(KC_T)
#define HRM_RGUI RCTL_T(KC_N)
#define HRM_RSFT RSFT_T(KC_E)
#define HRM_RALT RALT_T(KC_I)
#define HRM_RCTL RGUI_T(KC_O)

#define TAB_FN LT(fn, KC_TAB)

#define NAV_ESC LT(nav, KC_ESC)
#define NUM_SPC LT(num, KC_SPC)
#define WF_DICTATE_HOLD G(KC_F13)
#define WF_DICTATE_TOGGLE G(KC_F14)
#define WF_COMMAND_MODE G(KC_F15)

enum custom_keycodes {
    COLON_TAP = SAFE_RANGE,
    CW_CAPS,
};

static uint16_t cw_caps_timer = 0;

enum layers {
    colemak,
    nav,
    num,
    fn,
    media,
};

static void set_ctrl_gui_swap(bool swap) {
    keymap_config.swap_lctl_lgui = swap;
    keymap_config.swap_rctl_rgui = swap;
}

bool process_detected_host_os_user(os_variant_t detected_os) {
    switch (detected_os) {
        case OS_MACOS:
        case OS_IOS:
            set_ctrl_gui_swap(true);
            break;
        default:
            set_ctrl_gui_swap(false);
            break;
    }
    return true;
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case COLON_TAP:
            if (record->event.pressed) {
                tap_code16(KC_COLON);
            }
            return false;
        case CW_CAPS:
            if (record->event.pressed) {
                cw_caps_timer = timer_read();
            } else {
                if (timer_elapsed(cw_caps_timer) < TAPPING_TERM) {
                    caps_word_toggle();
                } else {
                    tap_code16(KC_CAPS);
                }
            }
            return false;
    }
    return true;
}


uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case HRM_LCTL:
        case HRM_LALT:
        case HRM_RALT:
        case HRM_RCTL:
            return 400;
    }
    return TAPPING_TERM;
}

uint16_t get_quick_tap_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case NAV_ESC:
        case NUM_SPC:
        case TAB_FN:
            return 0;
    }
    return QUICK_TAP_TERM;
}

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [colemak] = LAYOUT_split_3x5_3(
        //,--------------------------------------------.                    ,--------------------------------------------.
            KC_Q,    KC_W,    KC_F,    KC_P,    KC_B,                         KC_J,    KC_L,    KC_U,    KC_Y,    COLON_TAP,
        //|--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------|
            HRM_LCTL, HRM_LALT, HRM_LSFT, HRM_LGUI, KC_G,                    KC_M,    HRM_RGUI, HRM_RSFT, HRM_RALT, HRM_RCTL,
        //|--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------|
            KC_Z,    KC_X,    KC_C,    KC_D,    KC_V,                         KC_K,    KC_H,    KC_COMM,    KC_DOT,    KC_SLSH,
        //|--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------|
            KC_BSPC, NAV_ESC, TAB_FN,                                LT(media, KC_ENT), NUM_SPC, CW_CAPS
        //`-----------------------------------------------'  `-----------------------------------------------------'
    ),

    [nav] = LAYOUT_split_3x5_3(
        //,--------------------------------------------.                    ,--------------------------------------------.
            XX,    C(KC_X),    C(KC_V),    C(KC_C),    KC_PSCR,                                  XX,    XX, XX, XX, XX,
        //|--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------|
            KC_LGUI, KC_LALT, KC_LSFT, KC_LCTL, XX,                          KC_LEFT,    KC_DOWN,    KC_UP,    KC_RIGHT,    KC_SCLN,
        //|--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------|
            XX,    XX,    XX,    KC_MCTL, XX,                                   KC_PGDN,    KC_HOME, KC_END, KC_PGUP, KC_BSLS,
        //|--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------|
                                 XX,    __,    XX,              KC_ENT,    KC_SPC,    KC_BSPC
                             //`--------------------------'  `--------------------------'
    ),

    [num] = LAYOUT_split_3x5_3(
        //,--------------------------------------------.                    ,--------------------------------------------.
            KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                        KC_6,    KC_7,    KC_8,    KC_9,    KC_0,
        //|--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------|
            KC_LGUI, KC_LALT, KC_LSFT, KC_LCTL, KC_GRV,                            KC_TILDE,    KC_RCTL,    KC_RSFT,    KC_RALT,    KC_RGUI,
        //|--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------|
            XX,    XX,    KC_LBRC,    KC_RBRC, XX,                          XX,    KC_MINS,    KC_EQL,    KC_DOT, KC_SLSH,
        //|--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------|
                                 KC_BSPC,    KC_QUOT,    KC_DEL,              XX,    __,    XX
                             //`--------------------------'  `--------------------------'
    ),

    [fn] = LAYOUT_split_3x5_3(
        //,--------------------------------------------.                    ,--------------------------------------------.
            KC_F1,    KC_F2,    KC_F3,    KC_F4,    KC_F5,                  KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,
        //|--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------|
            KC_LGUI, KC_LALT, KC_LSFT, KC_LCTL, KC_F11,                         KC_F12,    KC_RCTL, KC_RSFT, KC_RALT, KC_RGUI,
        //|--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------|
            XX,    XX,    XX,    XX,    XX,             XX,    XX,    XX,    XX,    XX,
        //|--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------|
                               XX,    XX,    __,             XX,    XX,    XX
                           //`--------------------------'  `--------------------------'
    ),

    [media] = LAYOUT_split_3x5_3(
        //,--------------------------------------------.                    ,--------------------------------------------.
            QK_BOOT,    CG_TOGG,    XX,    XX,    XX,                             XX,    WF_DICTATE_HOLD,    WF_DICTATE_TOGGLE,    WF_COMMAND_MODE,    XX,
        //|--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------|
            XX,    XX,    KC_BRID,    KC_BRIU,  XX,                                XX,    KC_VOLD,    KC_VOLU,    KC_MUTE, XX,
        //|--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------|
            XX,    XX,    XX,    XX, XX,                                      XX,    XX,    XX,    XX,    XX,
        //|--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------|
                         KC_MPRV,    KC_MPLY,    KC_MNXT,              __,    XX,    XX
                             //`--------------------------'  `--------------------------'
    ),
};

#ifdef ENCODER_MAP_ENABLE
const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][NUM_DIRECTIONS] = {
    [0] = {
        ENCODER_CCW_CW(KC_VOLD, KC_VOLU),
        ENCODER_CCW_CW(KC_MPRV, KC_MNXT),
        ENCODER_CCW_CW(RM_VALD, RM_VALU),
        ENCODER_CCW_CW(KC_RGHT, KC_LEFT),
    },
    [1] = {
        ENCODER_CCW_CW(KC_VOLD, KC_VOLU),
        ENCODER_CCW_CW(KC_MPRV, KC_MNXT),
        ENCODER_CCW_CW(RM_VALD, RM_VALU),
        ENCODER_CCW_CW(KC_RGHT, KC_LEFT),
    },
    [2] = {
        ENCODER_CCW_CW(KC_VOLD, KC_VOLU),
        ENCODER_CCW_CW(KC_MPRV, KC_MNXT),
        ENCODER_CCW_CW(RM_VALD, RM_VALU),
        ENCODER_CCW_CW(KC_RGHT, KC_LEFT),
    },
    [3] = {
        ENCODER_CCW_CW(KC_VOLD, KC_VOLU),
        ENCODER_CCW_CW(KC_MPRV, KC_MNXT),
        ENCODER_CCW_CW(RM_VALD, RM_VALU),
        ENCODER_CCW_CW(KC_RGHT, KC_LEFT),
    },
};
#endif
