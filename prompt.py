import phind
import sys

prompt = sys.argv[1]

for result in phind.StreamingCompletion.create(
    model  = 'gpt-4',
    prompt = prompt,
    results     = phind.Search.create(prompt, actualSearch = True),
    creative    = False,
    detailed    = False,
    codeContext = ''):

    print(result.completion.choices[0].text, end='', flush=True)
