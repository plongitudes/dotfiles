;; extends

; Union-aware type captures (2026-08-01).
;
; The stock nvim-treesitter python query only awards @type to identifiers
; that are DIRECT children of (type ...), so members of a union annotation
; like `str | None` fall through to the bare any-of @type.builtin rule and
; render a different color than the same type written plainly (`host: str`).
; Same token, same meaning — the split is a query gap, not information.
;
; These patterns descend into `|` expressions (three levels covers realistic
; unions) and into subscripted members. Priority 101 deterministically beats
; the tie with the @type.builtin catch-all. The `;; extends` modeline is
; REQUIRED (verified on 0.12.3): without it this file replaces the base
; query instead of extending it.

((type
  (binary_operator
    (identifier) @type))
  (#set! priority 101))

((type
  (binary_operator
    (binary_operator
      (identifier) @type)))
  (#set! priority 101))

((type
  (binary_operator
    (binary_operator
      (binary_operator
        (identifier) @type))))
  (#set! priority 101))

((type
  (binary_operator
    (subscript
      (identifier) @type)))
  (#set! priority 101))

((type
  (binary_operator
    (binary_operator
      (subscript
        (identifier) @type))))
  (#set! priority 101))

; Note: `List[str] | None` parses as (union_type (type …) (type …)) — its
; members carry their own (type …) wrappers, so the base rules (and the
; uppercase naming-convention rule) already color them. (generic_type can't
; appear under binary_operator; such a pattern is rejected as impossible.)
