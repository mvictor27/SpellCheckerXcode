//
//  SourceEditorCommand.swift
//  Spelling
//
//  Created by Victor M on 27/03/2018.
//  Copyright © 2018 Victor M. All rights reserved.
//

import Foundation
import XcodeKit
import AppKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    let spellChecker = NSSpellChecker.shared

    let supportUTIs = ["public.swift-source"]

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.

        let uti = invocation.buffer.contentUTI

        guard supportUTIs.contains(uti) else {
            completionHandler(nil)
            return
        }

        spellChecker.learnWord("func")

        for line in invocation.buffer.lines.lazy.enumerated() {
            guard let stringLine = line.element as? String else {
                continue
            }

            let checkRange = spellChecker.checkSpelling(of: stringLine, startingAt: stringLine.startIndex.encodedOffset)

            if let word = stringLine.substring(with: checkRange) {
                let lineSelection = XCSourceTextRange()
                lineSelection.start = XCSourceTextPosition(line: line.offset, column: 0)
                lineSelection.end = XCSourceTextPosition(line: line.offset + 1, column: 0)
                invocation.buffer.selections.add(lineSelection)

                invocation.buffer.lines.add("Word \(word) is incorrect in line \(line.offset + 1)")
            }
        }

        completionHandler(nil)
    }
}
