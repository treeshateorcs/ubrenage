const std = @import("std");
const nouns = @embedFile("nouns");
const adjectives = @embedFile("adjectives");

const alphabet_length: u8 = 26;

pub fn main() !void {
    const random = std.crypto.random;
    var args_iter = std.process.args();
    _ = args_iter.next();
    const ra = @mod(random.int(u8), alphabet_length) + 'a';
    const rand_letter: []const u8 = &[_]u8{ra};

    const rand_letter_number_string: []const u8 = args_iter.next() orelse rand_letter;
    for (rand_letter_number_string) |letter| {
        if (letter < 'a' or letter > 'z') {
            usage();
            std.process.exit(1);
        }
        std.debug.print("{s} {s}\n", .{ randomWordFromList(adjectives, letter), randomWordFromList(nouns, letter) });
    }
}

fn randomWordFromList(list: []const u8, letter_number: i32) []const u8 {
    const rand = std.crypto.random;
    var it = std.mem.splitAny(u8, list, "\n");
    var alphabet_count = [_]i32{0} ** 26;
    while (it.next()) |noun| {
        if (noun.len > 0) {
            alphabet_count[noun[0] - 'a'] += 1;
        }
    }
    const rand_int = @mod(rand.int(i32), alphabet_count[@intCast(letter_number - 'a')]);
    var random_word_number: i32 = 0;
    for (alphabet_count, 0..) |letter, index| {
        if (index != letter_number - 'a') {
            random_word_number += letter;
        } else {
            break;
        }
    }
    random_word_number += rand_int;
    var it2 = std.mem.splitAny(u8, list, "\n");
    while (it2.next()) |noun| {
        if (random_word_number == 0) {
            return noun;
        }
        random_word_number -= 1;
    }
    return "";
}

fn usage() void {
    std.debug.print("usage: ubrenage [abcdefghijklmnopqrstuvwxyz...]\n", .{});
}
