
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Docs
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Reads and writes Google Docs documents.
## 
## https://developers.google.com/docs/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "docs"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DocsDocumentsCreate_578619 = ref object of OpenApiRestCall_578348
proc url_DocsDocumentsCreate_578621(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DocsDocumentsCreate_578620(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a blank document using the title given in the request. Other fields
  ## in the request, including any provided content, are ignored.
  ## 
  ## Returns the created document.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("$.xgafv")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("1"))
  if valid_578749 != nil:
    section.add "$.xgafv", valid_578749
  var valid_578750 = query.getOrDefault("alt")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("json"))
  if valid_578750 != nil:
    section.add "alt", valid_578750
  var valid_578751 = query.getOrDefault("uploadType")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "uploadType", valid_578751
  var valid_578752 = query.getOrDefault("quotaUser")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "quotaUser", valid_578752
  var valid_578753 = query.getOrDefault("callback")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "callback", valid_578753
  var valid_578754 = query.getOrDefault("fields")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "fields", valid_578754
  var valid_578755 = query.getOrDefault("access_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "access_token", valid_578755
  var valid_578756 = query.getOrDefault("upload_protocol")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "upload_protocol", valid_578756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578780: Call_DocsDocumentsCreate_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a blank document using the title given in the request. Other fields
  ## in the request, including any provided content, are ignored.
  ## 
  ## Returns the created document.
  ## 
  let valid = call_578780.validator(path, query, header, formData, body)
  let scheme = call_578780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578780.url(scheme.get, call_578780.host, call_578780.base,
                         call_578780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578780, url, valid)

proc call*(call_578851: Call_DocsDocumentsCreate_578619; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## docsDocumentsCreate
  ## Creates a blank document using the title given in the request. Other fields
  ## in the request, including any provided content, are ignored.
  ## 
  ## Returns the created document.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578852 = newJObject()
  var body_578854 = newJObject()
  add(query_578852, "key", newJString(key))
  add(query_578852, "prettyPrint", newJBool(prettyPrint))
  add(query_578852, "oauth_token", newJString(oauthToken))
  add(query_578852, "$.xgafv", newJString(Xgafv))
  add(query_578852, "alt", newJString(alt))
  add(query_578852, "uploadType", newJString(uploadType))
  add(query_578852, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578854 = body
  add(query_578852, "callback", newJString(callback))
  add(query_578852, "fields", newJString(fields))
  add(query_578852, "access_token", newJString(accessToken))
  add(query_578852, "upload_protocol", newJString(uploadProtocol))
  result = call_578851.call(nil, query_578852, nil, nil, body_578854)

var docsDocumentsCreate* = Call_DocsDocumentsCreate_578619(
    name: "docsDocumentsCreate", meth: HttpMethod.HttpPost,
    host: "docs.googleapis.com", route: "/v1/documents",
    validator: validate_DocsDocumentsCreate_578620, base: "/",
    url: url_DocsDocumentsCreate_578621, schemes: {Scheme.Https})
type
  Call_DocsDocumentsGet_578893 = ref object of OpenApiRestCall_578348
proc url_DocsDocumentsGet_578895(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "documentId" in path, "`documentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/documents/"),
               (kind: VariableSegment, value: "documentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DocsDocumentsGet_578894(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the latest version of the specified document.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   documentId: JString (required)
  ##             : The ID of the document to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `documentId` field"
  var valid_578910 = path.getOrDefault("documentId")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "documentId", valid_578910
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   suggestionsViewMode: JString
  ##                      : The suggestions view mode to apply to the document. This allows viewing the
  ## document with all suggestions inline, accepted or rejected. If one is not
  ## specified, DEFAULT_FOR_CURRENT_ACCESS is
  ## used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("prettyPrint")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(true))
  if valid_578912 != nil:
    section.add "prettyPrint", valid_578912
  var valid_578913 = query.getOrDefault("oauth_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "oauth_token", valid_578913
  var valid_578914 = query.getOrDefault("$.xgafv")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("1"))
  if valid_578914 != nil:
    section.add "$.xgafv", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("uploadType")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "uploadType", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("suggestionsViewMode")
  valid_578919 = validateParameter(valid_578919, JString, required = false, default = newJString(
      "DEFAULT_FOR_CURRENT_ACCESS"))
  if valid_578919 != nil:
    section.add "suggestionsViewMode", valid_578919
  var valid_578920 = query.getOrDefault("fields")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "fields", valid_578920
  var valid_578921 = query.getOrDefault("access_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "access_token", valid_578921
  var valid_578922 = query.getOrDefault("upload_protocol")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "upload_protocol", valid_578922
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578923: Call_DocsDocumentsGet_578893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest version of the specified document.
  ## 
  let valid = call_578923.validator(path, query, header, formData, body)
  let scheme = call_578923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578923.url(scheme.get, call_578923.host, call_578923.base,
                         call_578923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578923, url, valid)

proc call*(call_578924: Call_DocsDocumentsGet_578893; documentId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = "";
          suggestionsViewMode: string = "DEFAULT_FOR_CURRENT_ACCESS";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## docsDocumentsGet
  ## Gets the latest version of the specified document.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   documentId: string (required)
  ##             : The ID of the document to retrieve.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   suggestionsViewMode: string
  ##                      : The suggestions view mode to apply to the document. This allows viewing the
  ## document with all suggestions inline, accepted or rejected. If one is not
  ## specified, DEFAULT_FOR_CURRENT_ACCESS is
  ## used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578925 = newJObject()
  var query_578926 = newJObject()
  add(query_578926, "key", newJString(key))
  add(query_578926, "prettyPrint", newJBool(prettyPrint))
  add(query_578926, "oauth_token", newJString(oauthToken))
  add(path_578925, "documentId", newJString(documentId))
  add(query_578926, "$.xgafv", newJString(Xgafv))
  add(query_578926, "alt", newJString(alt))
  add(query_578926, "uploadType", newJString(uploadType))
  add(query_578926, "quotaUser", newJString(quotaUser))
  add(query_578926, "callback", newJString(callback))
  add(query_578926, "suggestionsViewMode", newJString(suggestionsViewMode))
  add(query_578926, "fields", newJString(fields))
  add(query_578926, "access_token", newJString(accessToken))
  add(query_578926, "upload_protocol", newJString(uploadProtocol))
  result = call_578924.call(path_578925, query_578926, nil, nil, nil)

var docsDocumentsGet* = Call_DocsDocumentsGet_578893(name: "docsDocumentsGet",
    meth: HttpMethod.HttpGet, host: "docs.googleapis.com",
    route: "/v1/documents/{documentId}", validator: validate_DocsDocumentsGet_578894,
    base: "/", url: url_DocsDocumentsGet_578895, schemes: {Scheme.Https})
type
  Call_DocsDocumentsBatchUpdate_578927 = ref object of OpenApiRestCall_578348
proc url_DocsDocumentsBatchUpdate_578929(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "documentId" in path, "`documentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/documents/"),
               (kind: VariableSegment, value: "documentId"),
               (kind: ConstantSegment, value: ":batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DocsDocumentsBatchUpdate_578928(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Applies one or more updates to the document.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid, then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how they are applied. Other requests do
  ## not need to return information; these each return an empty reply.
  ## The order of replies matches that of the requests.
  ## 
  ## For example, suppose you call batchUpdate with four updates, and only the
  ## third one returns information. The response would have two empty replies,
  ## the reply to the third request, and another empty reply, in that order.
  ## 
  ## Because other users may be editing the document, the document
  ## might not exactly reflect your changes: your changes may
  ## be altered with respect to collaborator changes. If there are no
  ## collaborators, the document should reflect your changes. In any case,
  ## the updates in your request are guaranteed to be applied together
  ## atomically.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   documentId: JString (required)
  ##             : The ID of the document to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `documentId` field"
  var valid_578930 = path.getOrDefault("documentId")
  valid_578930 = validateParameter(valid_578930, JString, required = true,
                                 default = nil)
  if valid_578930 != nil:
    section.add "documentId", valid_578930
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578931 = query.getOrDefault("key")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "key", valid_578931
  var valid_578932 = query.getOrDefault("prettyPrint")
  valid_578932 = validateParameter(valid_578932, JBool, required = false,
                                 default = newJBool(true))
  if valid_578932 != nil:
    section.add "prettyPrint", valid_578932
  var valid_578933 = query.getOrDefault("oauth_token")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "oauth_token", valid_578933
  var valid_578934 = query.getOrDefault("$.xgafv")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("1"))
  if valid_578934 != nil:
    section.add "$.xgafv", valid_578934
  var valid_578935 = query.getOrDefault("alt")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("json"))
  if valid_578935 != nil:
    section.add "alt", valid_578935
  var valid_578936 = query.getOrDefault("uploadType")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "uploadType", valid_578936
  var valid_578937 = query.getOrDefault("quotaUser")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "quotaUser", valid_578937
  var valid_578938 = query.getOrDefault("callback")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "callback", valid_578938
  var valid_578939 = query.getOrDefault("fields")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "fields", valid_578939
  var valid_578940 = query.getOrDefault("access_token")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "access_token", valid_578940
  var valid_578941 = query.getOrDefault("upload_protocol")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "upload_protocol", valid_578941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578943: Call_DocsDocumentsBatchUpdate_578927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Applies one or more updates to the document.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid, then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how they are applied. Other requests do
  ## not need to return information; these each return an empty reply.
  ## The order of replies matches that of the requests.
  ## 
  ## For example, suppose you call batchUpdate with four updates, and only the
  ## third one returns information. The response would have two empty replies,
  ## the reply to the third request, and another empty reply, in that order.
  ## 
  ## Because other users may be editing the document, the document
  ## might not exactly reflect your changes: your changes may
  ## be altered with respect to collaborator changes. If there are no
  ## collaborators, the document should reflect your changes. In any case,
  ## the updates in your request are guaranteed to be applied together
  ## atomically.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_DocsDocumentsBatchUpdate_578927; documentId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## docsDocumentsBatchUpdate
  ## Applies one or more updates to the document.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid, then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how they are applied. Other requests do
  ## not need to return information; these each return an empty reply.
  ## The order of replies matches that of the requests.
  ## 
  ## For example, suppose you call batchUpdate with four updates, and only the
  ## third one returns information. The response would have two empty replies,
  ## the reply to the third request, and another empty reply, in that order.
  ## 
  ## Because other users may be editing the document, the document
  ## might not exactly reflect your changes: your changes may
  ## be altered with respect to collaborator changes. If there are no
  ## collaborators, the document should reflect your changes. In any case,
  ## the updates in your request are guaranteed to be applied together
  ## atomically.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   documentId: string (required)
  ##             : The ID of the document to update.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  var body_578947 = newJObject()
  add(query_578946, "key", newJString(key))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  add(path_578945, "documentId", newJString(documentId))
  add(query_578946, "$.xgafv", newJString(Xgafv))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "uploadType", newJString(uploadType))
  add(query_578946, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578947 = body
  add(query_578946, "callback", newJString(callback))
  add(query_578946, "fields", newJString(fields))
  add(query_578946, "access_token", newJString(accessToken))
  add(query_578946, "upload_protocol", newJString(uploadProtocol))
  result = call_578944.call(path_578945, query_578946, nil, nil, body_578947)

var docsDocumentsBatchUpdate* = Call_DocsDocumentsBatchUpdate_578927(
    name: "docsDocumentsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "docs.googleapis.com", route: "/v1/documents/{documentId}:batchUpdate",
    validator: validate_DocsDocumentsBatchUpdate_578928, base: "/",
    url: url_DocsDocumentsBatchUpdate_578929, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
