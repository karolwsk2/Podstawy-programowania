# Hasło do logowania 
$password = "haslo123"

# Funkcja generowania losowego stanu konta
function Get-RandomAccountBalance {
    return [math]::Round((Get-Random -Minimum 1000 -Maximum 100000), 2)
}

# Inicjalizacja stanu konta
$global:accountBalance = Get-RandomAccountBalance

# Inicjalizacja historii transakcji
$global:transactionHistory = @()

# Funkcja logowania
function Login {
    param(
        [string]$inputPassword
    )

    if ($inputPassword -eq $password) {
        Write-Host "Logowanie powiodło się!"
        return $true
    } else {
        Write-Host "Niepoprawne hasło!"
        return $false
    }
}

# Funkcja pobierania stanu konta
function Get-AccountBalance {
    Write-Host "Aktualny stan konta: $($global:accountBalance)"
}

# Funkcja generowania losowej transakcji
function Get-RandomTransaction {
    $transactionTypes = @("Wpłata", "Wypłata")
    $randomTransactionType = $transactionTypes | Get-Random

    $transactionAmount = [math]::Round((Get-Random -Minimum 10 -Maximum 1000), 2)

    if ($randomTransactionType -eq "Wpłata") {
        $transactionAmount = $transactionAmount * 1
    } elseif ($randomTransactionType -eq "Wypłata") {
        $transactionAmount = $transactionAmount * -1
    }

    return @{
        Data = Get-Date
        Typ = $randomTransactionType
        Kwota = $transactionAmount
    }
}

# Funkcja generowania losowej historii transakcji
function Generate-RandomTransactionHistory {
    $transactionHistory = @()

    for ($i = 0; $i -lt (Get-Random -Minimum 10 -Maximum 50); $i++) {
        $transactionHistory += Get-RandomTransaction
    }

    return $transactionHistory
}

# Funkcja wyświetlania historii transakcji
function Show-TransactionHistory {
    if ($global:transactionHistory.Count -eq 0) {
        $global:transactionHistory = Generate-RandomTransactionHistory
    }

    Write-Host "Historia transakcji:"
    $global:transactionHistory | Format-Table -AutoSize
}

# Funkcja dodawania transakcji do historii
function Add-TransactionToHistory {
    param (
        [decimal]$amount,
        [string]$transactionType
    )

    $transaction = @{
        Data = Get-Date
        Typ = $transactionType
        Kwota = $amount
    }

    $global:transactionHistory += $transaction
}

# Funkcja wpłaty środków na konto
function Deposit {
    param(
        [decimal]$amount
    )

    $global:accountBalance += $amount

    Write-Host "Aktualny stan konta: $($global:accountBalance)"
    Write-Host "Kwota wpłaty: $($amount)"

    # Dodaj wpłatę do historii
    Add-TransactionToHistory -amount $amount -transactionType "Wpłata"
}

# Funkcja wypłaty środków z konta
function Withdraw {
    param(
        [decimal]$amount
    )

    if ($amount -le $global:accountBalance) {
        $global:accountBalance -= $amount

        Write-Host "Aktualny stan konta: $($global:accountBalance)"
        Write-Host "Kwota wypłaty: $($amount)"

        # Dodaj wypłatę do historii
        Add-TransactionToHistory -amount $amount -transactionType "Wypłata"
    } else {
        Write-Host "Nie masz wystarczających środków na koncie!"
    }
}

# Główny pętla programu
do {
    $passwordInput = Read-Host "Podaj hasło"
    $loggedIn = Login -inputPassword $passwordInput

    if ($loggedIn) {
        # Wyświetl stan konta przy uruchomieniu
        Get-AccountBalance

        $option = ""

        do {
            Write-Host "Wybierz opcję:"
            Write-Host "1. Historia transakcji"
            Write-Host "2. Wpłata"
            Write-Host "3. Wypłata"
            Write-Host "4. Wyloguj"
            Write-Host "5. Pokaz stan konta"

            $option = Read-Host "Twoja opcja"

            switch ($option) {
                1 { Show-TransactionHistory }  # Wyświetl historię transakcji
                2 { Deposit -amount (Read-Host "Podaj kwotę wpłaty") }  # Wykonaj wpłatę
                3 { Withdraw -amount (Read-Host "Podaj kwotę wypłaty") }  # Wykonaj wypłatę
                4 { Write-Host "Wylogowano"; break }  # Wyloguj użytkownika
                5 { Get-AccountBalance }  # Wyświetl stan konta
                default { Write-Host "Niepoprawna opcja!" }
            }
        } while ($option -ne "4")
    }
} while ($loggedIn -eq $false)
