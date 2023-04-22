import phind
import sys
import os

prompt = sys.argv[1]

phind.cf_clearance = os.environ["PROMPT_CF_COOKIE"]

for result in phind.StreamingCompletion.create(
    model  = 'gpt-4',
    prompt = prompt,
    results     = phind.Search.create(prompt, actualSearch = True),
    creative    = False,
    detailed    = False,
    codeContext = ''):

    print(result.completion.choices[0].text, end='', flush=True)
