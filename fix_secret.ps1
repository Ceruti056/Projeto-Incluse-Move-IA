# Script para remover a chave da API do histórico git
# Commit ofensivo: 65006cb7b7800755ad79af888c9951b4e36f7215

$repoRoot = "c:\Users\Gabriel\Desktop\project_inmove_ia\Projeto-Incluse-Move-IA"
$offendingCommit = "65006cb7b7800755ad79af888c9951b4e36f7215"
$filePath = "inclusive_move/lib/features/chat/providers/chat_provider.dart"
$fullFilePath = Join-Path $repoRoot "inclusive_move\lib\features\chat\providers\chat_provider.dart"

Set-Location $repoRoot

Write-Host "=== Iniciando rebase interativo para remover segredo ===" -ForegroundColor Cyan

# Define GIT_SEQUENCE_EDITOR para automatizar o rebase (marca 65006cb como 'edit')
$sequenceEditorScript = Join-Path $repoRoot "rebase_editor.ps1"
@"
param([string]`$file)
`$content = Get-Content `$file -Raw
`$content = `$content -replace '^pick 65006cb', 'edit 65006cb'
Set-Content `$file `$content -NoNewline
"@ | Set-Content $sequenceEditorScript

$env:GIT_SEQUENCE_EDITOR = "powershell -File `"$sequenceEditorScript`""

# Inicia o rebase a partir do commit pai do 65006cb
Write-Host "Iniciando rebase desde d5f78cb (pai de 65006cb)..." -ForegroundColor Yellow
git rebase -i d5f78cb

Write-Host "Rebase parado para edição. Estado atual:" -ForegroundColor Green
git status

