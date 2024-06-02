param(
    [array]$filters # Array de hashes contendo os detalhes dos filtros
)

# Função para gerar a CAML query para um único filtro
function Generate-CamlFilter {
    param(
        [string]$fieldName,
        [string]$fieldType,
        [string]$queryType,
        [string]$fieldValue
    )

    # Template da CAML query para um filtro
    $filterTemplate = @"
<{0}>
    <FieldRef Name='{1}' />
    <Value Type='{2}'>{3}</Value>
</{0}>
"@

    # Formatar a string CAML com os parâmetros fornecidos
    $camlFilter = [string]::Format($filterTemplate, $queryType, $fieldName, $fieldType, $fieldValue)
    return $camlFilter
}

# Função para combinar múltiplos filtros em uma única CAML query
function Generate-CamlQuery {
    param(
        [array]$filters
    )

    # Verificar se há múltiplos filtros
    if ($filters.Count -gt 1) {
        $combinedFilters = ""
        foreach ($filter in $filters) {
            $combinedFilters += Generate-CamlFilter -fieldName $filter.fieldName -fieldType $filter.fieldType -queryType $filter.queryType -fieldValue $filter.fieldValue
        }

        # Template da CAML query com múltiplos filtros combinados
        $camlTemplate = @"
<View>
    <Query>
        <Where>
            <And>
                {0}
            </And>
        </Where>
    </Query>
</View>
"@

        # Formatar a string CAML com os filtros combinados
        $camlQuery = [string]::Format($camlTemplate, $combinedFilters)
    } else {
        # Caso haja apenas um filtro, gerar a CAML query diretamente
        $filter = $filters[0]
        $camlQuery = @"
<View>
    <Query>
        <Where>
            $(Generate-CamlFilter -fieldName $filter.fieldName -fieldType $filter.fieldType -queryType $filter.queryType -fieldValue $filter.fieldValue)
        </Where>
    </Query>
</View>
"@
    }
    
    return $camlQuery
}

# Gerar a CAML query
$camlQuery = Generate-CamlQuery -filters $filters

# Exibir a CAML query
Write-Output "CAML Query gerada:"
Write-Output $camlQuery
