---
tags: swift, saga
type: article
summary: Um Hook React customizado para buscar dados de uma API
date: 2024-03-21
---

# useFetch, um Hook React customizado

Fazer requisições HTTP em aplicações React é uma tarefa comum, mas nem sempre simples. Com tantas opções disponíveis, como Axios e Fetch, escolher a abordagem certa pode ser desafiador. Para simplificar esse processo, apresento o Hook React customizado `useFetch`, uma solução elegante para lidar com requisições HTTP de forma simples e reutilizável nos seus projetos.

## Gerenciamento de estado:

Para começar nosso Hook, criamos estados para controlar o carregamento dos dados e possíveis erros. Usando o `useState` do React, definimos os estados `data`, `isLoading` e `error`.

```tsx
const [data, setData] = useState();
const [isLoading, setIsLoading] = useState(false);
const [error, setError] = useState<Error | undefined>();
```

## O estado data:

O estado `data` armazena os dados recebidos da API. Ele é inicializado como `undefined` e atualizado quando a requisição é bem-sucedida. Você também pode inicializar `data` com um valor padrão se quiser. Além disso, pode definir o tipo esperado para `data`.

## O estado isLoading:

`isLoading` é um booleano que indica se a requisição está em andamento. Ele começa como `false`, muda para `true` durante a requisição e volta para `false` quando ela termina.

## O estado error:

O estado `error` armazena possíveis erros que podem ocorrer durante a requisição. Ele é inicializado como `undefined` e atualizado com um objeto `Error` caso aconteça algum erro.

## A função fetchData:

A função `fetchData` é responsável por fazer a requisição para a API. Ela é uma função assíncrona que usa o método `fetch` do JavaScript. No bloco `try`, fazemos a requisição e convertemos a resposta para um objeto JSON. Quaisquer erros são capturados no bloco `catch` e armazenados no estado `error`. Por fim, o estado `isLoading` é atualizado para false no bloco `finally`.

```tsx
async function fetchData() {
  setIsLoading(true);
  try {
    const response = await fetch(url).then((res) => res.json());
    setData(response);
  } catch (error) {
    setError(error as Error);
  } finally {
    setIsLoading(false);
  }
}
```

## Usando useEffect:

Para fazer a requisição para a API, usamos o `useEffect` do React. Passamos a função `fetchData` como primeiro argumento e a dependência `url` como segundo argumento. Isso garante que a requisição seja feita sempre que a `url` mudar.

```tsx
useEffect(() => {
  fetchData();
}, [url]);
```

## A função refetch:

A função `refetch` é uma forma de refazer a requisição para a API manualmente. Ela é chamada quando queremos atualizar os dados, por exemplo quando o usuário clica em um botão de recarregar.

```tsx
function refetch() {
  setIsLoading(true);
  fetchData();
}
```

## Código completo

Aqui está o código completo do nosso Hook React customizado `useFetch`:

```tsx
import { useEffect, useState } from 'react';

export default function useFetch(url: string) {
  const [data, setData] = useState();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<Error | undefined>();

  async function fetchData() {
    setIsLoading(true);
    try {
      const response = await fetch(url).then((res) => res.json());
      setData(response);
    } catch (error) {
      setError(error as Error);
    } finally {
      setIsLoading(false);
    }
  }

  useEffect(() => {
    fetchData();
  }, [url]);

  function refetch() {
    setIsLoading(true);
    fetchData();
  }

  return { data, isLoading, error, refetch };
}
```

## Usando o Hook

Agora que o Hook está pronto, você pode usá-lo em qualquer componente da sua aplicação para fazer requisições para a API. Basta importar o Hook e chamar a função `useFetch`, passando a `url` da API como argumento.

```tsx
import useFetch from './useFetch';

export default function List() {
  const { data, isLoading, error, refetch } = useFetch("YOUR_API_URL");

  if (isLoading) {
    return <p>Loading...</p>;
  }

  if (error) {
    return <p>Error: {error.message}</p>;
  }

  return (
    // Render your list with the received data
  );
}
```

## Retorno do Hook

Por fim, retornamos um objeto contendo os estados `data`, `isLoading` e `error`, junto da função `refetch`. Isso nos permite usar esse Hook em diferentes partes da aplicação para fazer requisições de forma simples e reutilizável.

## Conclusão

O Hook React customizado `useFetch` simplifica o processo de fazer requisições HTTP em aplicações React. Com uma estrutura clara e funcionalidades bem definidas, ele permite um desenvolvimento mais eficiente e organizado. Experimente o `useFetch` no seu próximo projeto e veja como ele pode facilitar bastante a sua vida!

Espero que este artigo tenha sido útil para você. Se tiver dúvidas ou sugestões, não hesite em entrar em contato. Obrigado por ler até aqui e até a próxima! 🚀

