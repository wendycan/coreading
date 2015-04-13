# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Article.create([
  {title: 'Draft: JSX Specification',body: '
<div class="container"><div class="nav-main"><div class="wrap"><a class="nav-home" href="/jsx/">JSX</a><ul class="nav-site"><li><a href="http://github.com/facebook/jsx" class="">github</a></li></ul></div></div><div class="hero"><div class="wrap"><div class="text">Draft: <strong>JSX Specification</strong></div><div class="minitext">XML-like syntax extension to ECMAScript</div></div></div><section class="content wrap"><section class="home-section"><div><p>JSX is a XML-like syntax extension to ECMAScript without any defined semantics. It&#x27;s NOT intended to be implemented by engines or browsers. <strong>It&#x27;s NOT a proposal to incorporate JSX into the ECMAScript spec itself.</strong> It&#x27;s intended to be used by various preprocessors (transpilers) to transform these tokens into standard ECMAScript.</p><div class="prism language-javascript"><span class="token comment" spellcheck="true">// Using JSX to express UI components.
</span><span class="token keyword">var</span> dropdown <span class="token operator">=</span>
  &lt;Dropdown<span class="token operator">&gt;</span>
    A dropdown list
    &lt;Menu<span class="token operator">&gt;</span>
      &lt;MenuItem<span class="token operator">&gt;</span>Do Something&lt;<span class="token operator">/</span>MenuItem<span class="token operator">&gt;</span>
      &lt;MenuItem<span class="token operator">&gt;</span>Do Something Fun<span class="token operator">!</span>&lt;<span class="token operator">/</span>MenuItem<span class="token operator">&gt;</span>
      &lt;MenuItem<span class="token operator">&gt;</span>Do Something Else&lt;<span class="token operator">/</span>MenuItem<span class="token operator">&gt;</span>
    &lt;<span class="token operator">/</span>Menu<span class="token operator">&gt;</span>
  &lt;<span class="token operator">/</span>Dropdown<span class="token operator">&gt;</span><span class="token punctuation">;</span>

<span class="token function">render<span class="token punctuation">(</span></span>dropdown<span class="token punctuation">)</span><span class="token punctuation">;</span></div><h2><a class="anchor" name="rationale"></a>Rationale <a class="hash-link" href="#rationale">#</a></h2><p>The purpose of this specification is to define a concise and familiar syntax for defining tree structures with attributes. A generic but well defined syntax enables a community of independent parsers and syntax highlighters to conform to a single specification.</p><p>Embedding a new syntax in an existing language is a risky venture. Other syntax implementors or the existing language may introduce another incompatible syntax extension.</p><p>Through a stand-alone specification, we make it easier for implementors of other syntax extensions to consider JSX when designing their own syntax. This will hopefully allow various new syntax extensions to co-exist.</p><p>It is our intention to claim minimal syntactic real estate while keeping the syntax concise and familiar. That way we leave the door open for other extensions.</p><p>This specification does not attempt to comply with any XML or HTML specification. JSX is designed as an ECMAScript feature and the similarity to XML is only for familiarity.</p><h2><a class="anchor" name="syntax"></a>Syntax <a class="hash-link" href="#syntax">#</a></h2><p><em>JSX extends the PrimaryExpression in the <a href="http://people.mozilla.org/~jorendorff/es6-draft.html" target="_blank">ECMAScript 6th Edition (ECMA-262)</a> grammar:</em></p><p>PrimaryExpression :</p><ul><li>JSXElement</li></ul><p><strong>Elements</strong></p><p>JSXElement :</p><ul><li><p>JSXSelfClosingElement</p></li><li><p>JSXOpeningElement JSXChildren<sub>opt</sub> JSXClosingElement&lt;br /&gt;
(names of JSXOpeningElement and JSXClosingElement should match)</p></li></ul><p>JSXSelfClosingElement :</p><ul><li><code>&lt;</code> JSXElementName JSXAttributes<sub>opt</sub> <code>/</code> <code>&gt;</code></li></ul><p>JSXOpeningElement :</p><ul><li><code>&lt;</code> JSXElementName JSXAttributes<sub>opt</sub> <code>&gt;</code></li></ul><p>JSXClosingElement :</p><ul><li><code>&lt;</code> <code>/</code> JSXElementName <code>&gt;</code></li></ul><p>JSXElementName :</p><ul><li>JSXIdentifier</li><li>JSXNamedspacedName</li><li>JSXMemberExpression</li></ul><p>JSXIdentifier :</p><ul><li>IdentifierStart</li><li>JSXIdentifier IdentifierPart</li><li>JSXIdentifier <strong>NO WHITESPACE OR COMMENT</strong> <code>-</code></li></ul><p>JSXNamespacedName :</p><ul><li>JSXIdentifier <code>:</code> JSXIdentifier</li></ul><p>JSXMemberExpression :</p><ul><li>JSXIdentifier <code>.</code> JSXIdentifier</li><li>JSXMemberExpression <code>.</code> JSXIdentifier</li></ul><p><strong>Attributes</strong></p><p>JSXAttributes :</p><ul><li>JSXSpreadAttribute JSXAttributes<sub>opt</sub></li><li>JSXAttribute JSXAttributes<sub>opt</sub></li></ul><p>JSXSpreadAttribute :</p><ul><li><code>{</code> <code>...</code> AssignmentExpression <code>}</code></li></ul><p>JSXAttribute :</p><ul><li>JSXAttributeName <code>=</code> JSXAttributeValue</li></ul><p>JSXAttributeName :</p><ul><li>JSXIdentifier</li><li>JSXNamespacedName</li></ul><p>JSXAttributeValue :</p><ul><li><code>&quot;</code> JSXDoubleStringCharacters<sub>opt</sub> <code>&quot;</code></li><li><code>&#x27;</code> JSXSingleStringCharacters<sub>opt</sub> <code>&#x27;</code></li><li><code>{</code> AssignmentExpression <code>}</code></li><li>JSXElement</li></ul><p>JSXDoubleStringCharacters :</p><ul><li>JSXDoubleStringCharacter JSXDoubleStringCharacters<sub>opt</sub></li></ul><p>JSXDoubleStringCharacter :</p><ul><li>SourceCharacter <strong>but not <code>&quot;</code></strong></li></ul><p>JSXSingleStringCharacters :</p><ul><li>JSXSingleStringCharacter JSXSingleStringCharacters<sub>opt</sub></li></ul><p>JSXSingleStringCharacter :</p><ul><li>SourceCharacter <strong>but not <code>&#x27;</code></strong></li></ul><p><strong>Children</strong></p><p>JSXChildren :</p><ul><li>JSXChild JSXChildren<sub>opt</sub></li></ul><p>JSXChild :</p><ul><li>JSXText</li><li>JSXElement</li><li><code>{</code> AssignmentExpression<sub>opt</sub> <code>}</code></li></ul><p>JSXText :</p><ul><li>JSXTextCharacter JSXText<sub>opt</sub></li></ul><p>JSXTextCharacter :</p><ul><li>SourceCharacter <strong>but not one of <code>{</code>, <code>&lt;</code>, <code>&gt;</code> or <code>}</code></strong></li></ul><p><strong>Whitespace and Comments</strong></p><p><em>JSX uses the same punctuators and braces as ECMAScript. WhiteSpace, LineTerminators and Comments are generally allowed between any punctuators.</em></p><h2><a class="anchor" name="parser-implementations"></a>Parser Implementations <a class="hash-link" href="#parser-implementations">#</a></h2><ul><li><a href="https://github.com/RReverser/acorn-jsx" target="_blank">acorn-jsx</a>: A fork of acorn.</li><li><a href="https://github.com/facebook/esprima" target="_blank">esprima-fb</a>: A fork of esprima.</li><li><a href="https://github.com/jlongster/jsx-reader" target="_blank">jsx-reader</a>: A sweet.js macro.</li></ul><h2><a class="anchor" name="transpilers"></a>Transpilers <a class="hash-link" href="#transpilers">#</a></h2><p>These are a set of transpilers that all conform to the JSX syntax but use different semantics on the output:</p><ul><li><a href="https://github.com/vjeux/jsxdom" target="_blank">JSXDOM</a>: Create DOM elements using JSX.</li><li><a href="https://github.com/Raynos/mercury-jsx" target="_blank">Mercury JSX</a>: Create virtual-dom VNodes or VText using JSX.</li><li><a href="http://facebook.github.io/react/docs/jsx-in-depth.html" target="_blank">React JSX</a>: Create ReactElements using JSX.</li></ul><p>NOTE: A conforming transpiler may choose to use a subset of the JSX syntax.</p><h2><a class="anchor" name="why-not-template-literals"></a>Why not Template Literals? <a class="hash-link" href="#why-not-template-literals">#</a></h2><p><a href="http://people.mozilla.org/~jorendorff/es6-draft.html" target="_blank">ECMAScript 6th Edition (ECMA-262)</a> introduces template literals which are intended to be used for embedding DSL in ECMAScript. Why not just use that instead of inventing a syntax that&#x27;s not part of ECMAScript?</p><p>Template literals work well for long embedded DSLs. Unfortunately the syntax noise is substantial when you exit in and out of embedded arbitrary ECMAScript expressions with identifiers in scope.</p><div class="prism language-javascript"><span class="token comment" spellcheck="true">// Template Literals
</span><span class="token keyword">var</span> box <span class="token operator">=</span> jsx`
  &lt;$<span class="token punctuation">{</span>Box<span class="token punctuation">}</span><span class="token operator">&gt;</span>
    $<span class="token punctuation">{</span>
      <span class="token function">shouldShowAnswer<span class="token punctuation">(</span></span>user<span class="token punctuation">)</span> <span class="token operator">?</span>
      jsx`&lt;$<span class="token punctuation">{</span>Answer<span class="token punctuation">}</span> value<span class="token operator">=</span>$<span class="token punctuation">{</span><span class="token boolean">false</span><span class="token punctuation">}</span><span class="token operator">&gt;</span>no&lt;<span class="token operator">/</span>$<span class="token punctuation">{</span>Answer<span class="token punctuation">}</span><span class="token operator">&gt;</span>` <span class="token punctuation">:</span>
      jsx`
        &lt;$<span class="token punctuation">{</span>Box<span class="token punctuation">.</span>Comment<span class="token punctuation">}</span><span class="token operator">&gt;</span>
         Text Content
        &lt;<span class="token operator">/</span>$<span class="token punctuation">{</span>Box<span class="token punctuation">.</span>Comment<span class="token punctuation">}</span><span class="token operator">&gt;</span>
      `
    <span class="token punctuation">}</span>
  &lt;<span class="token operator">/</span>$<span class="token punctuation">{</span>Box<span class="token punctuation">}</span><span class="token operator">&gt;</span>
`<span class="token punctuation">;</span></div><p>It would be possible to use template literals as a syntactic entry point and change the semantics inside the template literal to allow embedded scripts that can be evaluated in scope:</p><div class="prism language-javascript"><span class="token comment" spellcheck="true">// Template Literals with embedded JSX
</span><span class="token keyword">var</span> box <span class="token operator">=</span> jsx`
  &lt;Box<span class="token operator">&gt;</span>
    <span class="token punctuation">{</span>
      <span class="token function">shouldShowAnswer<span class="token punctuation">(</span></span>user<span class="token punctuation">)</span> <span class="token operator">?</span>
      &lt;Answer value<span class="token operator">=</span><span class="token punctuation">{</span><span class="token boolean">false</span><span class="token punctuation">}</span><span class="token operator">&gt;</span>no&lt;<span class="token operator">/</span>Answer<span class="token operator">&gt;</span> <span class="token punctuation">:</span>
      &lt;Box<span class="token punctuation">.</span>Comment<span class="token operator">&gt;</span>
         Text Content
      &lt;<span class="token operator">/</span>Box<span class="token punctuation">.</span>Comment<span class="token operator">&gt;</span>
    <span class="token punctuation">}</span>
  &lt;<span class="token operator">/</span>Box<span class="token operator">&gt;</span>
`<span class="token punctuation">;</span></div><p>However, this would lead to further divergence. Tooling that is built around the assumptions imposed by template literals wouldn&#x27;t work. It would undermine the meaning of template literals. It would be necessary to define how JSX behaves within the rest of the ECMAScript grammar within the template literal anyway.</p><p>Therefore it&#x27;s better to introduce JSX as an entirely new type of PrimaryExpression:</p><div class="prism language-javascript"><span class="token comment" spellcheck="true">// JSX
</span><span class="token keyword">var</span> box <span class="token operator">=</span>
  &lt;Box<span class="token operator">&gt;</span>
    <span class="token punctuation">{</span>
      <span class="token function">shouldShowAnswer<span class="token punctuation">(</span></span>user<span class="token punctuation">)</span> <span class="token operator">?</span>
      &lt;Answer value<span class="token operator">=</span><span class="token punctuation">{</span><span class="token boolean">false</span><span class="token punctuation">}</span><span class="token operator">&gt;</span>no&lt;<span class="token operator">/</span>Answer<span class="token operator">&gt;</span> <span class="token punctuation">:</span>
      &lt;Box<span class="token punctuation">.</span>Comment<span class="token operator">&gt;</span>
         Text Content
      &lt;<span class="token operator">/</span>Box<span class="token punctuation">.</span>Comment<span class="token operator">&gt;</span>
    <span class="token punctuation">}</span>
  &lt;<span class="token operator">/</span>Box<span class="token operator">&gt;</span><span class="token punctuation">;</span></div><h2><a class="anchor" name="why-not-jxon"></a>Why not JXON? <a class="hash-link" href="#why-not-jxon">#</a></h2><p>Another alternative would be to use object initializers (similar to <a href="https://developer.mozilla.org/en-US/docs/JXON" target="_blank">JXON</a>). Unfortunately, the balanced braces do not give great syntactic hints for where an element starts and ends in large trees. Balanced named tags is a critical syntactic feature of the XML-style notation.</p><h2><a class="anchor" name="prior-art"></a>Prior Art <a class="hash-link" href="#prior-art">#</a></h2><p>The JSX syntax is similar to the <a href="http://www.ecma-international.org/publications/standards/Ecma-357.htm" target="_blank">E4X Specification (ECMA-357)</a>. E4X is a deprecated specification with deep reaching semantic meaning. JSX partially overlaps with a tiny subset of the E4X syntax. However, JSX has no relation to the E4X specification.</p><h2><a class="anchor" name="license"></a>License <a class="hash-link" href="#license">#</a></h2><p>Copyright (c) 2014, Facebook, Inc.
All rights reserved.</p><p>This work is licensed under a <a href="http://creativecommons.org/licenses/by/4.0/" target="_blank">Creative Commons Attribution 4.0
International License</a>.</p></div></section></section><footer class="wrap"><div class="right">© 2014 Facebook Inc.</div></footer></div><div id="fb-root"></div>'},
  {title: 'JSX in Depth',body: '<div class="inner-content">
    <h1>
      JSX in Depth
      <a class="edit-page-link" href="https://github.com/facebook/react/tree/master/docs/docs/02.1-jsx-in-depth.md" target="_blank">Edit on GitHub</a>
    </h1>
    <div class="subHeader"></div>

    <p><a href="http://facebook.github.io/jsx/">JSX</a> is a JavaScript syntax extension that looks similar to XML. You can use a simple JSX syntactic transform with React.</p>
<h2><a class="anchor" name="why-jsx"></a>Why JSX? <a class="hash-link" href="#why-jsx">#</a></h2>
<p>You don&#39;t have to use JSX with React. You can just use plain JS. However, we recommend using JSX because it is a concise and familiar syntax for defining tree structures with attributes.</p>

<p>It&#39;s more familiar for casual developers such as designers.</p>

<p>XML has the benefit of balanced opening and closing tags. This helps make large trees easier to read than function calls or object literals.</p>

<p>It doesn&#39;t alter the semantics of JavaScript.</p>
<h2><a class="anchor" name="html-tags-vs.-react-components"></a>HTML Tags vs. React Components <a class="hash-link" href="#html-tags-vs.-react-components">#</a></h2>
<p>React can either render HTML tags (strings) or React components (classes).</p>

<p>To render a HTML tag, just use lower-case tag names in JSX:</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="kd">var</span> <span class="nx">myDivElement</span> <span class="o">=</span> <span class="o">&lt;</span><span class="nx">div</span> <span class="nx">className</span><span class="o">=</span><span class="s2">&quot;foo&quot;</span> <span class="o">/&gt;</span><span class="p">;</span>
<span class="nx">React</span><span class="p">.</span><span class="nx">render</span><span class="p">(</span><span class="nx">myDivElement</span><span class="p">,</span> <span class="nb">document</span><span class="p">.</span><span class="nx">getElementById</span><span class="p">(</span><span class="s1">&#39;example&#39;</span><span class="p">));</span>
</code></pre></div>
<p>To render a React Component, just create a local variable that starts with an upper-case letter:</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="kd">var</span> <span class="nx">MyComponent</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createClass</span><span class="p">({</span><span class="cm">/*...*/</span><span class="p">});</span>
<span class="kd">var</span> <span class="nx">myElement</span> <span class="o">=</span> <span class="o">&lt;</span><span class="nx">MyComponent</span> <span class="nx">someProperty</span><span class="o">=</span><span class="p">{</span><span class="kc">true</span><span class="p">}</span> <span class="o">/&gt;</span><span class="p">;</span>
<span class="nx">React</span><span class="p">.</span><span class="nx">render</span><span class="p">(</span><span class="nx">myElement</span><span class="p">,</span> <span class="nb">document</span><span class="p">.</span><span class="nx">getElementById</span><span class="p">(</span><span class="s1">&#39;example&#39;</span><span class="p">));</span>
</code></pre></div>
<p>React&#39;s JSX uses the upper vs. lower case convention to distinguish between local component classes and HTML tags.</p>

<blockquote>
<p>Note:</p>

<p>Since JSX is JavaScript, identifiers such as <code>class</code> and <code>for</code> are discouraged
as XML attribute names. Instead, React DOM components expect DOM property
names like <code>className</code> and <code>htmlFor</code>, respectively.</p>
</blockquote>
<h2><a class="anchor" name="the-transform"></a>The Transform <a class="hash-link" href="#the-transform">#</a></h2>
<p>React JSX transforms from an XML-like syntax into native JavaScript. XML elements, attributes and children are transformed into arguments that are passed to <code>React.createElement</code>.</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="kd">var</span> <span class="nx">Nav</span><span class="p">;</span>
<span class="c1">// Input (JSX):</span>
<span class="kd">var</span> <span class="nx">app</span> <span class="o">=</span> <span class="o">&lt;</span><span class="nx">Nav</span> <span class="nx">color</span><span class="o">=</span><span class="s2">&quot;blue&quot;</span> <span class="o">/&gt;</span><span class="p">;</span>
<span class="c1">// Output (JS):</span>
<span class="kd">var</span> <span class="nx">app</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span><span class="nx">Nav</span><span class="p">,</span> <span class="p">{</span><span class="nx">color</span><span class="o">:</span><span class="s2">&quot;blue&quot;</span><span class="p">});</span>
</code></pre></div>
<p>Notice that in order to use <code>&lt;Nav /&gt;</code>, the <code>Nav</code> variable must be in scope.</p>

<p>JSX also allows specifying children using XML syntax:</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="kd">var</span> <span class="nx">Nav</span><span class="p">,</span> <span class="nx">Profile</span><span class="p">;</span>
<span class="c1">// Input (JSX):</span>
<span class="kd">var</span> <span class="nx">app</span> <span class="o">=</span> <span class="o">&lt;</span><span class="nx">Nav</span> <span class="nx">color</span><span class="o">=</span><span class="s2">&quot;blue&quot;</span><span class="o">&gt;&lt;</span><span class="nx">Profile</span><span class="o">&gt;</span><span class="nx">click</span><span class="o">&lt;</span><span class="err">/Profile&gt;&lt;/Nav&gt;;</span>
<span class="c1">// Output (JS):</span>
<span class="kd">var</span> <span class="nx">app</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span>
  <span class="nx">Nav</span><span class="p">,</span>
  <span class="p">{</span><span class="nx">color</span><span class="o">:</span><span class="s2">&quot;blue&quot;</span><span class="p">},</span>
  <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span><span class="nx">Profile</span><span class="p">,</span> <span class="kc">null</span><span class="p">,</span> <span class="s2">&quot;click&quot;</span><span class="p">)</span>
<span class="p">);</span>
</code></pre></div>
<p>JSX will infer the class&#39;s <a href="/react/docs/component-specs.html#displayname">displayName</a> from the variable assignment when the displayName is undefined:</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="c1">// Input (JSX):</span>
<span class="kd">var</span> <span class="nx">Nav</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createClass</span><span class="p">({</span> <span class="p">});</span>
<span class="c1">// Output (JS):</span>
<span class="kd">var</span> <span class="nx">Nav</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createClass</span><span class="p">({</span><span class="nx">displayName</span><span class="o">:</span> <span class="s2">&quot;Nav&quot;</span><span class="p">,</span> <span class="p">});</span>
</code></pre></div>
<p>Use the <a href="/react/jsx-compiler.html">JSX Compiler</a> to try out JSX and see how it
desugars into native JavaScript, and the
<a href="/react/html-jsx.html">HTML to JSX converter</a> to convert your existing HTML to
JSX.</p>

<p>If you want to use JSX, the <a href="/react/docs/getting-started.html">Getting Started</a> guide shows how to setup compilation.</p>

<blockquote>
<p>Note:</p>

<p>The JSX expression always evaluates to a ReactElement. The actual
implementation details may vary. An optimized mode could inline the
ReactElement as an object literal to bypass the validation code in
<code>React.createElement</code>.</p>
</blockquote>
<h2><a class="anchor" name="namespaced-components"></a>Namespaced Components <a class="hash-link" href="#namespaced-components">#</a></h2>
<p>If you are building a component that has many children, like a form, you might end up with something with a lot of variable declarations:</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="c1">// Awkward block of variable declarations</span>
<span class="kd">var</span> <span class="nx">Form</span> <span class="o">=</span> <span class="nx">MyFormComponent</span><span class="p">;</span>
<span class="kd">var</span> <span class="nx">FormRow</span> <span class="o">=</span> <span class="nx">Form</span><span class="p">.</span><span class="nx">Row</span><span class="p">;</span>
<span class="kd">var</span> <span class="nx">FormLabel</span> <span class="o">=</span> <span class="nx">Form</span><span class="p">.</span><span class="nx">Label</span><span class="p">;</span>
<span class="kd">var</span> <span class="nx">FormInput</span> <span class="o">=</span> <span class="nx">Form</span><span class="p">.</span><span class="nx">Input</span><span class="p">;</span>

<span class="kd">var</span> <span class="nx">App</span> <span class="o">=</span> <span class="p">(</span>
  <span class="o">&lt;</span><span class="nx">Form</span><span class="o">&gt;</span>
    <span class="o">&lt;</span><span class="nx">FormRow</span><span class="o">&gt;</span>
      <span class="o">&lt;</span><span class="nx">FormLabel</span> <span class="o">/&gt;</span>
      <span class="o">&lt;</span><span class="nx">FormInput</span> <span class="o">/&gt;</span>
    <span class="o">&lt;</span><span class="err">/FormRow&gt;</span>
  <span class="o">&lt;</span><span class="err">/Form&gt;</span>
<span class="p">);</span>
</code></pre></div>
<p>To make it simpler and easier, <em>namespaced components</em> let you use one component that has other components as attributes:</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="kd">var</span> <span class="nx">Form</span> <span class="o">=</span> <span class="nx">MyFormComponent</span><span class="p">;</span>

<span class="kd">var</span> <span class="nx">App</span> <span class="o">=</span> <span class="p">(</span>
  <span class="o">&lt;</span><span class="nx">Form</span><span class="o">&gt;</span>
    <span class="o">&lt;</span><span class="nx">Form</span><span class="p">.</span><span class="nx">Row</span><span class="o">&gt;</span>
      <span class="o">&lt;</span><span class="nx">Form</span><span class="p">.</span><span class="nx">Label</span> <span class="o">/&gt;</span>
      <span class="o">&lt;</span><span class="nx">Form</span><span class="p">.</span><span class="nx">Input</span> <span class="o">/&gt;</span>
    <span class="o">&lt;</span><span class="err">/Form.Row&gt;</span>
  <span class="o">&lt;</span><span class="err">/Form&gt;</span>
<span class="p">);</span>
</code></pre></div>
<p>To do this, you just need to create your <em>&quot;sub-components&quot;</em> as attributes of the main component:</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="kd">var</span> <span class="nx">MyFormComponent</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createClass</span><span class="p">({</span> <span class="p">...</span> <span class="p">});</span>

<span class="nx">MyFormComponent</span><span class="p">.</span><span class="nx">Row</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createClass</span><span class="p">({</span> <span class="p">...</span> <span class="p">});</span>
<span class="nx">MyFormComponent</span><span class="p">.</span><span class="nx">Label</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createClass</span><span class="p">({</span> <span class="p">...</span> <span class="p">});</span>
<span class="nx">MyFormComponent</span><span class="p">.</span><span class="nx">Input</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createClass</span><span class="p">({</span> <span class="p">...</span> <span class="p">});</span>
</code></pre></div>
<p>JSX will handle this properly when compiling your code.</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="kd">var</span> <span class="nx">App</span> <span class="o">=</span> <span class="p">(</span>
  <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span><span class="nx">Form</span><span class="p">,</span> <span class="kc">null</span><span class="p">,</span>
    <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span><span class="nx">Form</span><span class="p">.</span><span class="nx">Row</span><span class="p">,</span> <span class="kc">null</span><span class="p">,</span>
      <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span><span class="nx">Form</span><span class="p">.</span><span class="nx">Label</span><span class="p">,</span> <span class="kc">null</span><span class="p">),</span>
      <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span><span class="nx">Form</span><span class="p">.</span><span class="nx">Input</span><span class="p">,</span> <span class="kc">null</span><span class="p">)</span>
    <span class="p">)</span>
  <span class="p">)</span>
<span class="p">);</span>
</code></pre></div>
<blockquote>
<p>Note:</p>

<p>This feature is available in <a href="http://facebook.github.io/react/blog/2014/07/17/react-v0.11.html#jsx">v0.11</a> and above.</p>
</blockquote>
<h2><a class="anchor" name="javascript-expressions"></a>JavaScript Expressions <a class="hash-link" href="#javascript-expressions">#</a></h2><h3><a class="anchor" name="attribute-expressions"></a>Attribute Expressions <a class="hash-link" href="#attribute-expressions">#</a></h3>
<p>To use a JavaScript expression as an attribute value, wrap the expression in a
pair of curly braces (<code>{}</code>) instead of quotes (<code>&quot;&quot;</code>).</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="c1">// Input (JSX):</span>
<span class="kd">var</span> <span class="nx">person</span> <span class="o">=</span> <span class="o">&lt;</span><span class="nx">Person</span> <span class="nx">name</span><span class="o">=</span><span class="p">{</span><span class="nb">window</span><span class="p">.</span><span class="nx">isLoggedIn</span> <span class="o">?</span> <span class="nb">window</span><span class="p">.</span><span class="nx">name</span> <span class="o">:</span> <span class="s1">&#39;&#39;</span><span class="p">}</span> <span class="o">/&gt;</span><span class="p">;</span>
<span class="c1">// Output (JS):</span>
<span class="kd">var</span> <span class="nx">person</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span>
  <span class="nx">Person</span><span class="p">,</span>
  <span class="p">{</span><span class="nx">name</span><span class="o">:</span> <span class="nb">window</span><span class="p">.</span><span class="nx">isLoggedIn</span> <span class="o">?</span> <span class="nb">window</span><span class="p">.</span><span class="nx">name</span> <span class="o">:</span> <span class="s1">&#39;&#39;</span><span class="p">}</span>
<span class="p">);</span>
</code></pre></div><h3><a class="anchor" name="child-expressions"></a>Child Expressions <a class="hash-link" href="#child-expressions">#</a></h3>
<p>Likewise, JavaScript expressions may be used to express children:</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="c1">// Input (JSX):</span>
<span class="kd">var</span> <span class="nx">content</span> <span class="o">=</span> <span class="o">&lt;</span><span class="nx">Container</span><span class="o">&gt;</span><span class="p">{</span><span class="nb">window</span><span class="p">.</span><span class="nx">isLoggedIn</span> <span class="o">?</span> <span class="o">&lt;</span><span class="nx">Nav</span> <span class="o">/&gt;</span> <span class="o">:</span> <span class="o">&lt;</span><span class="nx">Login</span> <span class="o">/&gt;</span><span class="p">}</span><span class="o">&lt;</span><span class="err">/Container&gt;;</span>
<span class="c1">// Output (JS):</span>
<span class="kd">var</span> <span class="nx">content</span> <span class="o">=</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span>
  <span class="nx">Container</span><span class="p">,</span>
  <span class="kc">null</span><span class="p">,</span>
  <span class="nb">window</span><span class="p">.</span><span class="nx">isLoggedIn</span> <span class="o">?</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span><span class="nx">Nav</span><span class="p">)</span> <span class="o">:</span> <span class="nx">React</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span><span class="nx">Login</span><span class="p">)</span>
<span class="p">);</span>
</code></pre></div><h3><a class="anchor" name="comments"></a>Comments <a class="hash-link" href="#comments">#</a></h3>
<p>It&#39;s easy to add comments within your JSX; they&#39;re just JS expressions. You just need to be careful to put <code>{}</code> around the comments when you are within the children section of a tag.</p>
<div class="highlight"><pre><code class="language-javascript" data-lang="javascript"><span class="kd">var</span> <span class="nx">content</span> <span class="o">=</span> <span class="p">(</span>
  <span class="o">&lt;</span><span class="nx">Nav</span><span class="o">&gt;</span>
    <span class="p">{</span><span class="cm">/* child comment, put {} around */</span><span class="p">}</span>
    <span class="o">&lt;</span><span class="nx">Person</span>
      <span class="cm">/* multi</span>
<span class="cm">         line</span>
<span class="cm">         comment */</span>
      <span class="nx">name</span><span class="o">=</span><span class="p">{</span><span class="nb">window</span><span class="p">.</span><span class="nx">isLoggedIn</span> <span class="o">?</span> <span class="nb">window</span><span class="p">.</span><span class="nx">name</span> <span class="o">:</span> <span class="s1">&#39;&#39;</span><span class="p">}</span> <span class="c1">// end of line comment</span>
    <span class="o">/&gt;</span>
  <span class="o">&lt;</span><span class="err">/Nav&gt;</span>
<span class="p">);</span>
</code></pre></div>
<blockquote>
<p>NOTE:</p>

<p>JSX is similar to HTML, but not exactly the same. See <a href="/react/docs/jsx-gotchas.html">JSX gotchas</a> for some key differences.</p>
</blockquote>


    <div class="docs-prevnext">
      
        <a class="docs-prev" href="/react/docs/displaying-data.html">&larr; Prev</a>
      
      
        <a class="docs-next" href="/react/docs/jsx-spread.html">Next &rarr;</a>
      
    </div>
  </div>'}
])
