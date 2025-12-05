;; jicoin.clar
;; A simple fungible token smart contract for the JICoin project.

(define-fungible-token jicoin)

(define-data-var contract-owner (optional principal) none)

(define-constant ERR_UNAUTHORIZED u100)
(define-constant ERR_OWNER_ALREADY_SET u101)
(define-constant ERR_OWNER_NOT_SET u102)
(define-constant ERR_INSUFFICIENT_BALANCE u103)

;; ======== READ-ONLY HELPERS ========

(define-read-only (get-owner)
  (ok (var-get contract-owner)))

(define-read-only (is-owner (sender principal))
  (match (var-get contract-owner)
    owner-principal (is-eq sender owner-principal)
    false))

(define-read-only (get-balance (owner principal))
  (ok (ft-get-balance jicoin owner)))

(define-read-only (get-total-supply)
  (ok (ft-get-supply jicoin)))

;; ======== OWNER INITIALIZATION ========

;; One-time owner setup. The owner is typically the deployer address.
;; Can only be called once, and only by the account that will become owner.
(define-public (set-owner (owner principal))
  (begin
    (if (is-some (var-get contract-owner))
        (err ERR_OWNER_ALREADY_SET)
        (begin
          (asserts! (is-eq tx-sender owner) (err ERR_UNAUTHORIZED))
          (var-set contract-owner (some owner))
          (ok true)))))

;; ======== TOKEN OPERATIONS ========

;; Mint new JICoin tokens to a recipient.
;; Restricted to the contract owner.
(define-public (mint (recipient principal) (amount uint))
  (begin
    (if (not (is-owner tx-sender))
        (err ERR_UNAUTHORIZED)
        (ft-mint? jicoin amount recipient))))

;; Transfer JICoin from sender to recipient.
;; The tx-sender must match the declared sender.
(define-public (transfer (sender principal) (recipient principal) (amount uint))
  (begin
    (if (not (is-eq tx-sender sender))
        (err ERR_UNAUTHORIZED)
        (ft-transfer? jicoin amount sender recipient))))

;; Burn JICoin from the owner balance.
;; The tx-sender must match the owner.
(define-public (burn (owner principal) (amount uint))
  (begin
    (if (not (is-eq tx-sender owner))
        (err ERR_UNAUTHORIZED)
        (let ((balance (ft-get-balance jicoin owner)))
          (if (< balance amount)
              (err ERR_INSUFFICIENT_BALANCE)
              (ft-burn? jicoin amount owner))))))
