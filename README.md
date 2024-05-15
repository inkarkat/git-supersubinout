# git-supersubinout

This action shows incoming and outgoing commit logs between the commit recorded in the superproject for each submodule and that submodule's master branch.

When a superproject is used to tie together multiple components that reside in separate repositories (but share the same development lifecycle), any changes that have been merged onto the submodule's master branch should also be referenced in the superproject's master branch.
Pending submodule changes prevent another developer from cleanly integrating their changes into the superproject.
Submodules may also be accidentally rolled back to previous versions in an unrelated superproject commit.

By running this action every night, you can catch such discrepancies early, and alert developers that submodule commits on master are waiting to be referenced in the superproject / that the superproject has accidentally reverted some submodule references.

# Usage

```yaml
- name: Checkout repo
  uses: actions/checkout@v4
  with:
    submodules: recursive # Need to fetch the submodules as well
    fetch-depth: 0  # Need the full history for the submodule comparison
- uses: inkarkat/git-supersubinout@master
  id: supersubinout
  with:
    fail-on-differences: true # If you want to fail the build (vs. just checking whether there are differences)
- name: Proceed without differences # If you just want to react on the result without failing the build.
  if: steps.supersubinout.outputs.differences-found == 'false'
  run: echo '::notice::The build could proceed here.'
- name: Check summary # Provide a job summary with the differences
  if: failure()
  run: |
    cat >> "$GITHUB_STEP_SUMMARY" <<'EOF'
    ${{ steps.supersubinout.outputs.markdown-logs }}
    EOF
  shell: bash
```
# Example

![workflow run](workflow-run.png)
