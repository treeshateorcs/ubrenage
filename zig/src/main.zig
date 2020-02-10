const std = @import("std");
const warn = std.debug.warn;
const adjectives = @embedFile("adjectives");
const nouns = @embedFile("nouns");

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.direct_allocator);
    defer arena.deinit();
    var nouns_count = calculate_words(nouns);
    var adjectives_count = calculate_words(adjectives);
    adjust(&nouns_count);
    adjust(&adjectives_count);
    var arg_it = std.process.args();
    _ = arg_it.skip();
    const arg = try (arg_it.next(&arena.allocator) orelse {
        var letter = random_letter();
        var random_noun_number = random_number(nouns_count, letter);
        var random_adj_number = random_number(adjectives_count, letter);
        var noun = random_word(random_noun_number, nouns, &arena.allocator);
        var adjective = random_word(random_adj_number, adjectives, &arena.allocator);
        warn("{} {}\n", .{ adjective, noun });
        return;
    });
    for (arg) |symbol| {
        if (symbol < 97 or symbol > 122) {
            usage();
            return;
        }
        var letter = symbol - 97;
        var random_noun_number = random_number(nouns_count, letter);
        var random_adj_number = random_number(adjectives_count, letter);
        var noun = random_word(random_noun_number, nouns, &arena.allocator);
        var adjective = random_word(random_adj_number, adjectives, &arena.allocator);
        warn("{} {}\n", .{ adjective, noun });
        return;
    }
}

fn random_word(number: i32, words: []const u8, allocator: *std.mem.Allocator) ![]u8 {
    var words_number: i32 = 0;
    var result = try std.Buffer.init(allocator, "");
    for (words) |letter| {
        if (letter == '\n') {
            words_number += 1;
        } else if (words_number == number) {
            _ = try result.appendByte(letter);
        }
    }
    return result.toOwnedSlice();
}

fn random_number(map: [27]i32, letter: i32) i32 {
    var start = map[@intCast(usize, letter)];
    var end = map[@intCast(usize, letter) + 1];
    var rand = std.rand.DefaultPrng.init(std.time.milliTimestamp());
    return rand.random.intRangeAtMost(i32, start, end);
}

fn random_letter() i32 {
    var rand = std.rand.DefaultPrng.init(std.time.milliTimestamp());
    return rand.random.intRangeAtMost(i32, 0, 26);
}

fn adjust(words_num: var) void {
    var i: usize = 1;
    while (i < words_num.len - 1) {
        words_num[i] += words_num[i - 1];
        i += 1;
    }
}

fn calculate_words(words: []const u8) [27]i32 {
    var letters: [27]i32 = [_]i32{0} ** 27;
    var nouns_count: i32 = 1; // number of lines (nouns) total
    var beg_word: bool = true; // the beginnig of a line (word)
    for (words) |letter| {
        if (letter == '\n') {
            nouns_count += 1;
            beg_word = true;
        } else if (beg_word) {
            letters[letter - 96] += 1;
            beg_word = false;
        }
    }
    letters[26] = nouns_count;
    return letters;
}

fn usage() void {
    warn("usage: ubrenage [abcdefghijklmnopqrstuvwxyz...]", .{});
}
