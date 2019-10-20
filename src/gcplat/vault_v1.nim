
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: G Suite Vault
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Archiving and eDiscovery for G Suite.
## 
## https://developers.google.com/vault
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
  gcpServiceName = "vault"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VaultMattersCreate_578895 = ref object of OpenApiRestCall_578348
proc url_VaultMattersCreate_578897(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VaultMattersCreate_578896(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a new matter with the given name and description. The initial state
  ## is open, and the owner is the method caller. Returns the created matter
  ## with default view.
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
  var valid_578898 = query.getOrDefault("key")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "key", valid_578898
  var valid_578899 = query.getOrDefault("prettyPrint")
  valid_578899 = validateParameter(valid_578899, JBool, required = false,
                                 default = newJBool(true))
  if valid_578899 != nil:
    section.add "prettyPrint", valid_578899
  var valid_578900 = query.getOrDefault("oauth_token")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "oauth_token", valid_578900
  var valid_578901 = query.getOrDefault("$.xgafv")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = newJString("1"))
  if valid_578901 != nil:
    section.add "$.xgafv", valid_578901
  var valid_578902 = query.getOrDefault("alt")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = newJString("json"))
  if valid_578902 != nil:
    section.add "alt", valid_578902
  var valid_578903 = query.getOrDefault("uploadType")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "uploadType", valid_578903
  var valid_578904 = query.getOrDefault("quotaUser")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "quotaUser", valid_578904
  var valid_578905 = query.getOrDefault("callback")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "callback", valid_578905
  var valid_578906 = query.getOrDefault("fields")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "fields", valid_578906
  var valid_578907 = query.getOrDefault("access_token")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "access_token", valid_578907
  var valid_578908 = query.getOrDefault("upload_protocol")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "upload_protocol", valid_578908
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

proc call*(call_578910: Call_VaultMattersCreate_578895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new matter with the given name and description. The initial state
  ## is open, and the owner is the method caller. Returns the created matter
  ## with default view.
  ## 
  let valid = call_578910.validator(path, query, header, formData, body)
  let scheme = call_578910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578910.url(scheme.get, call_578910.host, call_578910.base,
                         call_578910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578910, url, valid)

proc call*(call_578911: Call_VaultMattersCreate_578895; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersCreate
  ## Creates a new matter with the given name and description. The initial state
  ## is open, and the owner is the method caller. Returns the created matter
  ## with default view.
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
  var query_578912 = newJObject()
  var body_578913 = newJObject()
  add(query_578912, "key", newJString(key))
  add(query_578912, "prettyPrint", newJBool(prettyPrint))
  add(query_578912, "oauth_token", newJString(oauthToken))
  add(query_578912, "$.xgafv", newJString(Xgafv))
  add(query_578912, "alt", newJString(alt))
  add(query_578912, "uploadType", newJString(uploadType))
  add(query_578912, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578913 = body
  add(query_578912, "callback", newJString(callback))
  add(query_578912, "fields", newJString(fields))
  add(query_578912, "access_token", newJString(accessToken))
  add(query_578912, "upload_protocol", newJString(uploadProtocol))
  result = call_578911.call(nil, query_578912, nil, nil, body_578913)

var vaultMattersCreate* = Call_VaultMattersCreate_578895(
    name: "vaultMattersCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters",
    validator: validate_VaultMattersCreate_578896, base: "/",
    url: url_VaultMattersCreate_578897, schemes: {Scheme.Https})
type
  Call_VaultMattersList_578619 = ref object of OpenApiRestCall_578348
proc url_VaultMattersList_578621(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VaultMattersList_578620(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists matters the user has access to.
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
  ##   state: JString
  ##        : If set, list only matters with that specific state. The default is listing
  ## matters of all states.
  ##   pageSize: JInt
  ##           : The number of matters to return in the response.
  ## Default and maximum are 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pagination token as returned in the response.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Specifies which parts of the matter to return in response.
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
  var valid_578750 = query.getOrDefault("state")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("STATE_UNSPECIFIED"))
  if valid_578750 != nil:
    section.add "state", valid_578750
  var valid_578751 = query.getOrDefault("pageSize")
  valid_578751 = validateParameter(valid_578751, JInt, required = false, default = nil)
  if valid_578751 != nil:
    section.add "pageSize", valid_578751
  var valid_578752 = query.getOrDefault("alt")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = newJString("json"))
  if valid_578752 != nil:
    section.add "alt", valid_578752
  var valid_578753 = query.getOrDefault("uploadType")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "uploadType", valid_578753
  var valid_578754 = query.getOrDefault("quotaUser")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "quotaUser", valid_578754
  var valid_578755 = query.getOrDefault("pageToken")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "pageToken", valid_578755
  var valid_578756 = query.getOrDefault("callback")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "callback", valid_578756
  var valid_578757 = query.getOrDefault("fields")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "fields", valid_578757
  var valid_578758 = query.getOrDefault("access_token")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "access_token", valid_578758
  var valid_578759 = query.getOrDefault("upload_protocol")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "upload_protocol", valid_578759
  var valid_578760 = query.getOrDefault("view")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_578760 != nil:
    section.add "view", valid_578760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578783: Call_VaultMattersList_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matters the user has access to.
  ## 
  let valid = call_578783.validator(path, query, header, formData, body)
  let scheme = call_578783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578783.url(scheme.get, call_578783.host, call_578783.base,
                         call_578783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578783, url, valid)

proc call*(call_578854: Call_VaultMattersList_578619; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          state: string = "STATE_UNSPECIFIED"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "VIEW_UNSPECIFIED"): Recallable =
  ## vaultMattersList
  ## Lists matters the user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   state: string
  ##        : If set, list only matters with that specific state. The default is listing
  ## matters of all states.
  ##   pageSize: int
  ##           : The number of matters to return in the response.
  ## Default and maximum are 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The pagination token as returned in the response.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Specifies which parts of the matter to return in response.
  var query_578855 = newJObject()
  add(query_578855, "key", newJString(key))
  add(query_578855, "prettyPrint", newJBool(prettyPrint))
  add(query_578855, "oauth_token", newJString(oauthToken))
  add(query_578855, "$.xgafv", newJString(Xgafv))
  add(query_578855, "state", newJString(state))
  add(query_578855, "pageSize", newJInt(pageSize))
  add(query_578855, "alt", newJString(alt))
  add(query_578855, "uploadType", newJString(uploadType))
  add(query_578855, "quotaUser", newJString(quotaUser))
  add(query_578855, "pageToken", newJString(pageToken))
  add(query_578855, "callback", newJString(callback))
  add(query_578855, "fields", newJString(fields))
  add(query_578855, "access_token", newJString(accessToken))
  add(query_578855, "upload_protocol", newJString(uploadProtocol))
  add(query_578855, "view", newJString(view))
  result = call_578854.call(nil, query_578855, nil, nil, nil)

var vaultMattersList* = Call_VaultMattersList_578619(name: "vaultMattersList",
    meth: HttpMethod.HttpGet, host: "vault.googleapis.com", route: "/v1/matters",
    validator: validate_VaultMattersList_578620, base: "/",
    url: url_VaultMattersList_578621, schemes: {Scheme.Https})
type
  Call_VaultMattersUpdate_578948 = ref object of OpenApiRestCall_578348
proc url_VaultMattersUpdate_578950(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersUpdate_578949(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the specified matter.
  ## This updates only the name and description of the matter, identified by
  ## matter id. Changes to any other fields are ignored.
  ## Returns the default view of the matter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_578951 = path.getOrDefault("matterId")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "matterId", valid_578951
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
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("$.xgafv")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("1"))
  if valid_578955 != nil:
    section.add "$.xgafv", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("uploadType")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "uploadType", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("callback")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "callback", valid_578959
  var valid_578960 = query.getOrDefault("fields")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "fields", valid_578960
  var valid_578961 = query.getOrDefault("access_token")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "access_token", valid_578961
  var valid_578962 = query.getOrDefault("upload_protocol")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "upload_protocol", valid_578962
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

proc call*(call_578964: Call_VaultMattersUpdate_578948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified matter.
  ## This updates only the name and description of the matter, identified by
  ## matter id. Changes to any other fields are ignored.
  ## Returns the default view of the matter.
  ## 
  let valid = call_578964.validator(path, query, header, formData, body)
  let scheme = call_578964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578964.url(scheme.get, call_578964.host, call_578964.base,
                         call_578964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578964, url, valid)

proc call*(call_578965: Call_VaultMattersUpdate_578948; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersUpdate
  ## Updates the specified matter.
  ## This updates only the name and description of the matter, identified by
  ## matter id. Changes to any other fields are ignored.
  ## Returns the default view of the matter.
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
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578966 = newJObject()
  var query_578967 = newJObject()
  var body_578968 = newJObject()
  add(query_578967, "key", newJString(key))
  add(query_578967, "prettyPrint", newJBool(prettyPrint))
  add(query_578967, "oauth_token", newJString(oauthToken))
  add(query_578967, "$.xgafv", newJString(Xgafv))
  add(query_578967, "alt", newJString(alt))
  add(query_578967, "uploadType", newJString(uploadType))
  add(query_578967, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578968 = body
  add(query_578967, "callback", newJString(callback))
  add(path_578966, "matterId", newJString(matterId))
  add(query_578967, "fields", newJString(fields))
  add(query_578967, "access_token", newJString(accessToken))
  add(query_578967, "upload_protocol", newJString(uploadProtocol))
  result = call_578965.call(path_578966, query_578967, nil, nil, body_578968)

var vaultMattersUpdate* = Call_VaultMattersUpdate_578948(
    name: "vaultMattersUpdate", meth: HttpMethod.HttpPut,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}",
    validator: validate_VaultMattersUpdate_578949, base: "/",
    url: url_VaultMattersUpdate_578950, schemes: {Scheme.Https})
type
  Call_VaultMattersGet_578914 = ref object of OpenApiRestCall_578348
proc url_VaultMattersGet_578916(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersGet_578915(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the specified matter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_578931 = path.getOrDefault("matterId")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "matterId", valid_578931
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
  ##   view: JString
  ##       : Specifies which parts of the Matter to return in the response.
  section = newJObject()
  var valid_578932 = query.getOrDefault("key")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "key", valid_578932
  var valid_578933 = query.getOrDefault("prettyPrint")
  valid_578933 = validateParameter(valid_578933, JBool, required = false,
                                 default = newJBool(true))
  if valid_578933 != nil:
    section.add "prettyPrint", valid_578933
  var valid_578934 = query.getOrDefault("oauth_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "oauth_token", valid_578934
  var valid_578935 = query.getOrDefault("$.xgafv")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("1"))
  if valid_578935 != nil:
    section.add "$.xgafv", valid_578935
  var valid_578936 = query.getOrDefault("alt")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("json"))
  if valid_578936 != nil:
    section.add "alt", valid_578936
  var valid_578937 = query.getOrDefault("uploadType")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "uploadType", valid_578937
  var valid_578938 = query.getOrDefault("quotaUser")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "quotaUser", valid_578938
  var valid_578939 = query.getOrDefault("callback")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "callback", valid_578939
  var valid_578940 = query.getOrDefault("fields")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "fields", valid_578940
  var valid_578941 = query.getOrDefault("access_token")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "access_token", valid_578941
  var valid_578942 = query.getOrDefault("upload_protocol")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "upload_protocol", valid_578942
  var valid_578943 = query.getOrDefault("view")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_578943 != nil:
    section.add "view", valid_578943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578944: Call_VaultMattersGet_578914; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified matter.
  ## 
  let valid = call_578944.validator(path, query, header, formData, body)
  let scheme = call_578944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578944.url(scheme.get, call_578944.host, call_578944.base,
                         call_578944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578944, url, valid)

proc call*(call_578945: Call_VaultMattersGet_578914; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          view: string = "VIEW_UNSPECIFIED"): Recallable =
  ## vaultMattersGet
  ## Gets the specified matter.
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
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Specifies which parts of the Matter to return in the response.
  var path_578946 = newJObject()
  var query_578947 = newJObject()
  add(query_578947, "key", newJString(key))
  add(query_578947, "prettyPrint", newJBool(prettyPrint))
  add(query_578947, "oauth_token", newJString(oauthToken))
  add(query_578947, "$.xgafv", newJString(Xgafv))
  add(query_578947, "alt", newJString(alt))
  add(query_578947, "uploadType", newJString(uploadType))
  add(query_578947, "quotaUser", newJString(quotaUser))
  add(query_578947, "callback", newJString(callback))
  add(path_578946, "matterId", newJString(matterId))
  add(query_578947, "fields", newJString(fields))
  add(query_578947, "access_token", newJString(accessToken))
  add(query_578947, "upload_protocol", newJString(uploadProtocol))
  add(query_578947, "view", newJString(view))
  result = call_578945.call(path_578946, query_578947, nil, nil, nil)

var vaultMattersGet* = Call_VaultMattersGet_578914(name: "vaultMattersGet",
    meth: HttpMethod.HttpGet, host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}", validator: validate_VaultMattersGet_578915,
    base: "/", url: url_VaultMattersGet_578916, schemes: {Scheme.Https})
type
  Call_VaultMattersDelete_578969 = ref object of OpenApiRestCall_578348
proc url_VaultMattersDelete_578971(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersDelete_578970(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified matter. Returns matter with updated state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_578972 = path.getOrDefault("matterId")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "matterId", valid_578972
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
  var valid_578973 = query.getOrDefault("key")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "key", valid_578973
  var valid_578974 = query.getOrDefault("prettyPrint")
  valid_578974 = validateParameter(valid_578974, JBool, required = false,
                                 default = newJBool(true))
  if valid_578974 != nil:
    section.add "prettyPrint", valid_578974
  var valid_578975 = query.getOrDefault("oauth_token")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "oauth_token", valid_578975
  var valid_578976 = query.getOrDefault("$.xgafv")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = newJString("1"))
  if valid_578976 != nil:
    section.add "$.xgafv", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("json"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("uploadType")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "uploadType", valid_578978
  var valid_578979 = query.getOrDefault("quotaUser")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "quotaUser", valid_578979
  var valid_578980 = query.getOrDefault("callback")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "callback", valid_578980
  var valid_578981 = query.getOrDefault("fields")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "fields", valid_578981
  var valid_578982 = query.getOrDefault("access_token")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "access_token", valid_578982
  var valid_578983 = query.getOrDefault("upload_protocol")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "upload_protocol", valid_578983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578984: Call_VaultMattersDelete_578969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_578984.validator(path, query, header, formData, body)
  let scheme = call_578984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578984.url(scheme.get, call_578984.host, call_578984.base,
                         call_578984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578984, url, valid)

proc call*(call_578985: Call_VaultMattersDelete_578969; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersDelete
  ## Deletes the specified matter. Returns matter with updated state.
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
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578986 = newJObject()
  var query_578987 = newJObject()
  add(query_578987, "key", newJString(key))
  add(query_578987, "prettyPrint", newJBool(prettyPrint))
  add(query_578987, "oauth_token", newJString(oauthToken))
  add(query_578987, "$.xgafv", newJString(Xgafv))
  add(query_578987, "alt", newJString(alt))
  add(query_578987, "uploadType", newJString(uploadType))
  add(query_578987, "quotaUser", newJString(quotaUser))
  add(query_578987, "callback", newJString(callback))
  add(path_578986, "matterId", newJString(matterId))
  add(query_578987, "fields", newJString(fields))
  add(query_578987, "access_token", newJString(accessToken))
  add(query_578987, "upload_protocol", newJString(uploadProtocol))
  result = call_578985.call(path_578986, query_578987, nil, nil, nil)

var vaultMattersDelete* = Call_VaultMattersDelete_578969(
    name: "vaultMattersDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}",
    validator: validate_VaultMattersDelete_578970, base: "/",
    url: url_VaultMattersDelete_578971, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsCreate_579009 = ref object of OpenApiRestCall_578348
proc url_VaultMattersExportsCreate_579011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/exports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersExportsCreate_579010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an Export.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_579012 = path.getOrDefault("matterId")
  valid_579012 = validateParameter(valid_579012, JString, required = true,
                                 default = nil)
  if valid_579012 != nil:
    section.add "matterId", valid_579012
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
  var valid_579013 = query.getOrDefault("key")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "key", valid_579013
  var valid_579014 = query.getOrDefault("prettyPrint")
  valid_579014 = validateParameter(valid_579014, JBool, required = false,
                                 default = newJBool(true))
  if valid_579014 != nil:
    section.add "prettyPrint", valid_579014
  var valid_579015 = query.getOrDefault("oauth_token")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "oauth_token", valid_579015
  var valid_579016 = query.getOrDefault("$.xgafv")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("1"))
  if valid_579016 != nil:
    section.add "$.xgafv", valid_579016
  var valid_579017 = query.getOrDefault("alt")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = newJString("json"))
  if valid_579017 != nil:
    section.add "alt", valid_579017
  var valid_579018 = query.getOrDefault("uploadType")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "uploadType", valid_579018
  var valid_579019 = query.getOrDefault("quotaUser")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "quotaUser", valid_579019
  var valid_579020 = query.getOrDefault("callback")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "callback", valid_579020
  var valid_579021 = query.getOrDefault("fields")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "fields", valid_579021
  var valid_579022 = query.getOrDefault("access_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "access_token", valid_579022
  var valid_579023 = query.getOrDefault("upload_protocol")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "upload_protocol", valid_579023
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

proc call*(call_579025: Call_VaultMattersExportsCreate_579009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an Export.
  ## 
  let valid = call_579025.validator(path, query, header, formData, body)
  let scheme = call_579025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579025.url(scheme.get, call_579025.host, call_579025.base,
                         call_579025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579025, url, valid)

proc call*(call_579026: Call_VaultMattersExportsCreate_579009; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersExportsCreate
  ## Creates an Export.
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
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579027 = newJObject()
  var query_579028 = newJObject()
  var body_579029 = newJObject()
  add(query_579028, "key", newJString(key))
  add(query_579028, "prettyPrint", newJBool(prettyPrint))
  add(query_579028, "oauth_token", newJString(oauthToken))
  add(query_579028, "$.xgafv", newJString(Xgafv))
  add(query_579028, "alt", newJString(alt))
  add(query_579028, "uploadType", newJString(uploadType))
  add(query_579028, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579029 = body
  add(query_579028, "callback", newJString(callback))
  add(path_579027, "matterId", newJString(matterId))
  add(query_579028, "fields", newJString(fields))
  add(query_579028, "access_token", newJString(accessToken))
  add(query_579028, "upload_protocol", newJString(uploadProtocol))
  result = call_579026.call(path_579027, query_579028, nil, nil, body_579029)

var vaultMattersExportsCreate* = Call_VaultMattersExportsCreate_579009(
    name: "vaultMattersExportsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/exports",
    validator: validate_VaultMattersExportsCreate_579010, base: "/",
    url: url_VaultMattersExportsCreate_579011, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsList_578988 = ref object of OpenApiRestCall_578348
proc url_VaultMattersExportsList_578990(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/exports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersExportsList_578989(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Exports.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_578991 = path.getOrDefault("matterId")
  valid_578991 = validateParameter(valid_578991, JString, required = true,
                                 default = nil)
  if valid_578991 != nil:
    section.add "matterId", valid_578991
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
  ##   pageSize: JInt
  ##           : The number of exports to return in the response.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pagination token as returned in the response.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578992 = query.getOrDefault("key")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "key", valid_578992
  var valid_578993 = query.getOrDefault("prettyPrint")
  valid_578993 = validateParameter(valid_578993, JBool, required = false,
                                 default = newJBool(true))
  if valid_578993 != nil:
    section.add "prettyPrint", valid_578993
  var valid_578994 = query.getOrDefault("oauth_token")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "oauth_token", valid_578994
  var valid_578995 = query.getOrDefault("$.xgafv")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("1"))
  if valid_578995 != nil:
    section.add "$.xgafv", valid_578995
  var valid_578996 = query.getOrDefault("pageSize")
  valid_578996 = validateParameter(valid_578996, JInt, required = false, default = nil)
  if valid_578996 != nil:
    section.add "pageSize", valid_578996
  var valid_578997 = query.getOrDefault("alt")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("json"))
  if valid_578997 != nil:
    section.add "alt", valid_578997
  var valid_578998 = query.getOrDefault("uploadType")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "uploadType", valid_578998
  var valid_578999 = query.getOrDefault("quotaUser")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "quotaUser", valid_578999
  var valid_579000 = query.getOrDefault("pageToken")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "pageToken", valid_579000
  var valid_579001 = query.getOrDefault("callback")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "callback", valid_579001
  var valid_579002 = query.getOrDefault("fields")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "fields", valid_579002
  var valid_579003 = query.getOrDefault("access_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "access_token", valid_579003
  var valid_579004 = query.getOrDefault("upload_protocol")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "upload_protocol", valid_579004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579005: Call_VaultMattersExportsList_578988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists Exports.
  ## 
  let valid = call_579005.validator(path, query, header, formData, body)
  let scheme = call_579005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579005.url(scheme.get, call_579005.host, call_579005.base,
                         call_579005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579005, url, valid)

proc call*(call_579006: Call_VaultMattersExportsList_578988; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersExportsList
  ## Lists Exports.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of exports to return in the response.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The pagination token as returned in the response.
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579007 = newJObject()
  var query_579008 = newJObject()
  add(query_579008, "key", newJString(key))
  add(query_579008, "prettyPrint", newJBool(prettyPrint))
  add(query_579008, "oauth_token", newJString(oauthToken))
  add(query_579008, "$.xgafv", newJString(Xgafv))
  add(query_579008, "pageSize", newJInt(pageSize))
  add(query_579008, "alt", newJString(alt))
  add(query_579008, "uploadType", newJString(uploadType))
  add(query_579008, "quotaUser", newJString(quotaUser))
  add(query_579008, "pageToken", newJString(pageToken))
  add(query_579008, "callback", newJString(callback))
  add(path_579007, "matterId", newJString(matterId))
  add(query_579008, "fields", newJString(fields))
  add(query_579008, "access_token", newJString(accessToken))
  add(query_579008, "upload_protocol", newJString(uploadProtocol))
  result = call_579006.call(path_579007, query_579008, nil, nil, nil)

var vaultMattersExportsList* = Call_VaultMattersExportsList_578988(
    name: "vaultMattersExportsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/exports",
    validator: validate_VaultMattersExportsList_578989, base: "/",
    url: url_VaultMattersExportsList_578990, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsGet_579030 = ref object of OpenApiRestCall_578348
proc url_VaultMattersExportsGet_579032(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "exportId" in path, "`exportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/exports/"),
               (kind: VariableSegment, value: "exportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersExportsGet_579031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an Export.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   exportId: JString (required)
  ##           : The export ID.
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `exportId` field"
  var valid_579033 = path.getOrDefault("exportId")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "exportId", valid_579033
  var valid_579034 = path.getOrDefault("matterId")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "matterId", valid_579034
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
  var valid_579035 = query.getOrDefault("key")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "key", valid_579035
  var valid_579036 = query.getOrDefault("prettyPrint")
  valid_579036 = validateParameter(valid_579036, JBool, required = false,
                                 default = newJBool(true))
  if valid_579036 != nil:
    section.add "prettyPrint", valid_579036
  var valid_579037 = query.getOrDefault("oauth_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "oauth_token", valid_579037
  var valid_579038 = query.getOrDefault("$.xgafv")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("1"))
  if valid_579038 != nil:
    section.add "$.xgafv", valid_579038
  var valid_579039 = query.getOrDefault("alt")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = newJString("json"))
  if valid_579039 != nil:
    section.add "alt", valid_579039
  var valid_579040 = query.getOrDefault("uploadType")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "uploadType", valid_579040
  var valid_579041 = query.getOrDefault("quotaUser")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "quotaUser", valid_579041
  var valid_579042 = query.getOrDefault("callback")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "callback", valid_579042
  var valid_579043 = query.getOrDefault("fields")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "fields", valid_579043
  var valid_579044 = query.getOrDefault("access_token")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "access_token", valid_579044
  var valid_579045 = query.getOrDefault("upload_protocol")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "upload_protocol", valid_579045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579046: Call_VaultMattersExportsGet_579030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an Export.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_VaultMattersExportsGet_579030; exportId: string;
          matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersExportsGet
  ## Gets an Export.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   exportId: string (required)
  ##           : The export ID.
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
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579048 = newJObject()
  var query_579049 = newJObject()
  add(query_579049, "key", newJString(key))
  add(query_579049, "prettyPrint", newJBool(prettyPrint))
  add(query_579049, "oauth_token", newJString(oauthToken))
  add(path_579048, "exportId", newJString(exportId))
  add(query_579049, "$.xgafv", newJString(Xgafv))
  add(query_579049, "alt", newJString(alt))
  add(query_579049, "uploadType", newJString(uploadType))
  add(query_579049, "quotaUser", newJString(quotaUser))
  add(query_579049, "callback", newJString(callback))
  add(path_579048, "matterId", newJString(matterId))
  add(query_579049, "fields", newJString(fields))
  add(query_579049, "access_token", newJString(accessToken))
  add(query_579049, "upload_protocol", newJString(uploadProtocol))
  result = call_579047.call(path_579048, query_579049, nil, nil, nil)

var vaultMattersExportsGet* = Call_VaultMattersExportsGet_579030(
    name: "vaultMattersExportsGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/exports/{exportId}",
    validator: validate_VaultMattersExportsGet_579031, base: "/",
    url: url_VaultMattersExportsGet_579032, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsDelete_579050 = ref object of OpenApiRestCall_578348
proc url_VaultMattersExportsDelete_579052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "exportId" in path, "`exportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/exports/"),
               (kind: VariableSegment, value: "exportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersExportsDelete_579051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Export.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   exportId: JString (required)
  ##           : The export ID.
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `exportId` field"
  var valid_579053 = path.getOrDefault("exportId")
  valid_579053 = validateParameter(valid_579053, JString, required = true,
                                 default = nil)
  if valid_579053 != nil:
    section.add "exportId", valid_579053
  var valid_579054 = path.getOrDefault("matterId")
  valid_579054 = validateParameter(valid_579054, JString, required = true,
                                 default = nil)
  if valid_579054 != nil:
    section.add "matterId", valid_579054
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
  var valid_579055 = query.getOrDefault("key")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "key", valid_579055
  var valid_579056 = query.getOrDefault("prettyPrint")
  valid_579056 = validateParameter(valid_579056, JBool, required = false,
                                 default = newJBool(true))
  if valid_579056 != nil:
    section.add "prettyPrint", valid_579056
  var valid_579057 = query.getOrDefault("oauth_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "oauth_token", valid_579057
  var valid_579058 = query.getOrDefault("$.xgafv")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = newJString("1"))
  if valid_579058 != nil:
    section.add "$.xgafv", valid_579058
  var valid_579059 = query.getOrDefault("alt")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("json"))
  if valid_579059 != nil:
    section.add "alt", valid_579059
  var valid_579060 = query.getOrDefault("uploadType")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "uploadType", valid_579060
  var valid_579061 = query.getOrDefault("quotaUser")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "quotaUser", valid_579061
  var valid_579062 = query.getOrDefault("callback")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "callback", valid_579062
  var valid_579063 = query.getOrDefault("fields")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "fields", valid_579063
  var valid_579064 = query.getOrDefault("access_token")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "access_token", valid_579064
  var valid_579065 = query.getOrDefault("upload_protocol")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "upload_protocol", valid_579065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579066: Call_VaultMattersExportsDelete_579050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Export.
  ## 
  let valid = call_579066.validator(path, query, header, formData, body)
  let scheme = call_579066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579066.url(scheme.get, call_579066.host, call_579066.base,
                         call_579066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579066, url, valid)

proc call*(call_579067: Call_VaultMattersExportsDelete_579050; exportId: string;
          matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersExportsDelete
  ## Deletes an Export.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   exportId: string (required)
  ##           : The export ID.
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
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579068 = newJObject()
  var query_579069 = newJObject()
  add(query_579069, "key", newJString(key))
  add(query_579069, "prettyPrint", newJBool(prettyPrint))
  add(query_579069, "oauth_token", newJString(oauthToken))
  add(path_579068, "exportId", newJString(exportId))
  add(query_579069, "$.xgafv", newJString(Xgafv))
  add(query_579069, "alt", newJString(alt))
  add(query_579069, "uploadType", newJString(uploadType))
  add(query_579069, "quotaUser", newJString(quotaUser))
  add(query_579069, "callback", newJString(callback))
  add(path_579068, "matterId", newJString(matterId))
  add(query_579069, "fields", newJString(fields))
  add(query_579069, "access_token", newJString(accessToken))
  add(query_579069, "upload_protocol", newJString(uploadProtocol))
  result = call_579067.call(path_579068, query_579069, nil, nil, nil)

var vaultMattersExportsDelete* = Call_VaultMattersExportsDelete_579050(
    name: "vaultMattersExportsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/exports/{exportId}",
    validator: validate_VaultMattersExportsDelete_579051, base: "/",
    url: url_VaultMattersExportsDelete_579052, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsCreate_579092 = ref object of OpenApiRestCall_578348
proc url_VaultMattersHoldsCreate_579094(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/holds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersHoldsCreate_579093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a hold in the given matter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_579095 = path.getOrDefault("matterId")
  valid_579095 = validateParameter(valid_579095, JString, required = true,
                                 default = nil)
  if valid_579095 != nil:
    section.add "matterId", valid_579095
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
  var valid_579096 = query.getOrDefault("key")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "key", valid_579096
  var valid_579097 = query.getOrDefault("prettyPrint")
  valid_579097 = validateParameter(valid_579097, JBool, required = false,
                                 default = newJBool(true))
  if valid_579097 != nil:
    section.add "prettyPrint", valid_579097
  var valid_579098 = query.getOrDefault("oauth_token")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "oauth_token", valid_579098
  var valid_579099 = query.getOrDefault("$.xgafv")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = newJString("1"))
  if valid_579099 != nil:
    section.add "$.xgafv", valid_579099
  var valid_579100 = query.getOrDefault("alt")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = newJString("json"))
  if valid_579100 != nil:
    section.add "alt", valid_579100
  var valid_579101 = query.getOrDefault("uploadType")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "uploadType", valid_579101
  var valid_579102 = query.getOrDefault("quotaUser")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "quotaUser", valid_579102
  var valid_579103 = query.getOrDefault("callback")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "callback", valid_579103
  var valid_579104 = query.getOrDefault("fields")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "fields", valid_579104
  var valid_579105 = query.getOrDefault("access_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "access_token", valid_579105
  var valid_579106 = query.getOrDefault("upload_protocol")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "upload_protocol", valid_579106
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

proc call*(call_579108: Call_VaultMattersHoldsCreate_579092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a hold in the given matter.
  ## 
  let valid = call_579108.validator(path, query, header, formData, body)
  let scheme = call_579108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579108.url(scheme.get, call_579108.host, call_579108.base,
                         call_579108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579108, url, valid)

proc call*(call_579109: Call_VaultMattersHoldsCreate_579092; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersHoldsCreate
  ## Creates a hold in the given matter.
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
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579110 = newJObject()
  var query_579111 = newJObject()
  var body_579112 = newJObject()
  add(query_579111, "key", newJString(key))
  add(query_579111, "prettyPrint", newJBool(prettyPrint))
  add(query_579111, "oauth_token", newJString(oauthToken))
  add(query_579111, "$.xgafv", newJString(Xgafv))
  add(query_579111, "alt", newJString(alt))
  add(query_579111, "uploadType", newJString(uploadType))
  add(query_579111, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579112 = body
  add(query_579111, "callback", newJString(callback))
  add(path_579110, "matterId", newJString(matterId))
  add(query_579111, "fields", newJString(fields))
  add(query_579111, "access_token", newJString(accessToken))
  add(query_579111, "upload_protocol", newJString(uploadProtocol))
  result = call_579109.call(path_579110, query_579111, nil, nil, body_579112)

var vaultMattersHoldsCreate* = Call_VaultMattersHoldsCreate_579092(
    name: "vaultMattersHoldsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds",
    validator: validate_VaultMattersHoldsCreate_579093, base: "/",
    url: url_VaultMattersHoldsCreate_579094, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsList_579070 = ref object of OpenApiRestCall_578348
proc url_VaultMattersHoldsList_579072(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/holds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersHoldsList_579071(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists holds within a matter. An empty page token in ListHoldsResponse
  ## denotes no more holds to list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_579073 = path.getOrDefault("matterId")
  valid_579073 = validateParameter(valid_579073, JString, required = true,
                                 default = nil)
  if valid_579073 != nil:
    section.add "matterId", valid_579073
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
  ##   pageSize: JInt
  ##           : The number of holds to return in the response, between 0 and 100 inclusive.
  ## Leaving this empty, or as 0, is the same as page_size = 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pagination token as returned in the response.
  ## An empty token means start from the beginning.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Specifies which parts of the Hold to return.
  section = newJObject()
  var valid_579074 = query.getOrDefault("key")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "key", valid_579074
  var valid_579075 = query.getOrDefault("prettyPrint")
  valid_579075 = validateParameter(valid_579075, JBool, required = false,
                                 default = newJBool(true))
  if valid_579075 != nil:
    section.add "prettyPrint", valid_579075
  var valid_579076 = query.getOrDefault("oauth_token")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "oauth_token", valid_579076
  var valid_579077 = query.getOrDefault("$.xgafv")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = newJString("1"))
  if valid_579077 != nil:
    section.add "$.xgafv", valid_579077
  var valid_579078 = query.getOrDefault("pageSize")
  valid_579078 = validateParameter(valid_579078, JInt, required = false, default = nil)
  if valid_579078 != nil:
    section.add "pageSize", valid_579078
  var valid_579079 = query.getOrDefault("alt")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = newJString("json"))
  if valid_579079 != nil:
    section.add "alt", valid_579079
  var valid_579080 = query.getOrDefault("uploadType")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "uploadType", valid_579080
  var valid_579081 = query.getOrDefault("quotaUser")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "quotaUser", valid_579081
  var valid_579082 = query.getOrDefault("pageToken")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "pageToken", valid_579082
  var valid_579083 = query.getOrDefault("callback")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "callback", valid_579083
  var valid_579084 = query.getOrDefault("fields")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "fields", valid_579084
  var valid_579085 = query.getOrDefault("access_token")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "access_token", valid_579085
  var valid_579086 = query.getOrDefault("upload_protocol")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "upload_protocol", valid_579086
  var valid_579087 = query.getOrDefault("view")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = newJString("HOLD_VIEW_UNSPECIFIED"))
  if valid_579087 != nil:
    section.add "view", valid_579087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579088: Call_VaultMattersHoldsList_579070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists holds within a matter. An empty page token in ListHoldsResponse
  ## denotes no more holds to list.
  ## 
  let valid = call_579088.validator(path, query, header, formData, body)
  let scheme = call_579088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579088.url(scheme.get, call_579088.host, call_579088.base,
                         call_579088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579088, url, valid)

proc call*(call_579089: Call_VaultMattersHoldsList_579070; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "HOLD_VIEW_UNSPECIFIED"): Recallable =
  ## vaultMattersHoldsList
  ## Lists holds within a matter. An empty page token in ListHoldsResponse
  ## denotes no more holds to list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of holds to return in the response, between 0 and 100 inclusive.
  ## Leaving this empty, or as 0, is the same as page_size = 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The pagination token as returned in the response.
  ## An empty token means start from the beginning.
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Specifies which parts of the Hold to return.
  var path_579090 = newJObject()
  var query_579091 = newJObject()
  add(query_579091, "key", newJString(key))
  add(query_579091, "prettyPrint", newJBool(prettyPrint))
  add(query_579091, "oauth_token", newJString(oauthToken))
  add(query_579091, "$.xgafv", newJString(Xgafv))
  add(query_579091, "pageSize", newJInt(pageSize))
  add(query_579091, "alt", newJString(alt))
  add(query_579091, "uploadType", newJString(uploadType))
  add(query_579091, "quotaUser", newJString(quotaUser))
  add(query_579091, "pageToken", newJString(pageToken))
  add(query_579091, "callback", newJString(callback))
  add(path_579090, "matterId", newJString(matterId))
  add(query_579091, "fields", newJString(fields))
  add(query_579091, "access_token", newJString(accessToken))
  add(query_579091, "upload_protocol", newJString(uploadProtocol))
  add(query_579091, "view", newJString(view))
  result = call_579089.call(path_579090, query_579091, nil, nil, nil)

var vaultMattersHoldsList* = Call_VaultMattersHoldsList_579070(
    name: "vaultMattersHoldsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds",
    validator: validate_VaultMattersHoldsList_579071, base: "/",
    url: url_VaultMattersHoldsList_579072, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsUpdate_579134 = ref object of OpenApiRestCall_578348
proc url_VaultMattersHoldsUpdate_579136(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "holdId" in path, "`holdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/holds/"),
               (kind: VariableSegment, value: "holdId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersHoldsUpdate_579135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the OU and/or query parameters of a hold. You cannot add accounts
  ## to a hold that covers an OU, nor can you add OUs to a hold that covers
  ## individual accounts. Accounts listed in the hold will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   holdId: JString (required)
  ##         : The ID of the hold.
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `holdId` field"
  var valid_579137 = path.getOrDefault("holdId")
  valid_579137 = validateParameter(valid_579137, JString, required = true,
                                 default = nil)
  if valid_579137 != nil:
    section.add "holdId", valid_579137
  var valid_579138 = path.getOrDefault("matterId")
  valid_579138 = validateParameter(valid_579138, JString, required = true,
                                 default = nil)
  if valid_579138 != nil:
    section.add "matterId", valid_579138
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
  var valid_579139 = query.getOrDefault("key")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "key", valid_579139
  var valid_579140 = query.getOrDefault("prettyPrint")
  valid_579140 = validateParameter(valid_579140, JBool, required = false,
                                 default = newJBool(true))
  if valid_579140 != nil:
    section.add "prettyPrint", valid_579140
  var valid_579141 = query.getOrDefault("oauth_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "oauth_token", valid_579141
  var valid_579142 = query.getOrDefault("$.xgafv")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = newJString("1"))
  if valid_579142 != nil:
    section.add "$.xgafv", valid_579142
  var valid_579143 = query.getOrDefault("alt")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = newJString("json"))
  if valid_579143 != nil:
    section.add "alt", valid_579143
  var valid_579144 = query.getOrDefault("uploadType")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "uploadType", valid_579144
  var valid_579145 = query.getOrDefault("quotaUser")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "quotaUser", valid_579145
  var valid_579146 = query.getOrDefault("callback")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "callback", valid_579146
  var valid_579147 = query.getOrDefault("fields")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "fields", valid_579147
  var valid_579148 = query.getOrDefault("access_token")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "access_token", valid_579148
  var valid_579149 = query.getOrDefault("upload_protocol")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "upload_protocol", valid_579149
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

proc call*(call_579151: Call_VaultMattersHoldsUpdate_579134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the OU and/or query parameters of a hold. You cannot add accounts
  ## to a hold that covers an OU, nor can you add OUs to a hold that covers
  ## individual accounts. Accounts listed in the hold will be ignored.
  ## 
  let valid = call_579151.validator(path, query, header, formData, body)
  let scheme = call_579151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579151.url(scheme.get, call_579151.host, call_579151.base,
                         call_579151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579151, url, valid)

proc call*(call_579152: Call_VaultMattersHoldsUpdate_579134; holdId: string;
          matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersHoldsUpdate
  ## Updates the OU and/or query parameters of a hold. You cannot add accounts
  ## to a hold that covers an OU, nor can you add OUs to a hold that covers
  ## individual accounts. Accounts listed in the hold will be ignored.
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
  ##   holdId: string (required)
  ##         : The ID of the hold.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579153 = newJObject()
  var query_579154 = newJObject()
  var body_579155 = newJObject()
  add(query_579154, "key", newJString(key))
  add(query_579154, "prettyPrint", newJBool(prettyPrint))
  add(query_579154, "oauth_token", newJString(oauthToken))
  add(query_579154, "$.xgafv", newJString(Xgafv))
  add(query_579154, "alt", newJString(alt))
  add(query_579154, "uploadType", newJString(uploadType))
  add(query_579154, "quotaUser", newJString(quotaUser))
  add(path_579153, "holdId", newJString(holdId))
  if body != nil:
    body_579155 = body
  add(query_579154, "callback", newJString(callback))
  add(path_579153, "matterId", newJString(matterId))
  add(query_579154, "fields", newJString(fields))
  add(query_579154, "access_token", newJString(accessToken))
  add(query_579154, "upload_protocol", newJString(uploadProtocol))
  result = call_579152.call(path_579153, query_579154, nil, nil, body_579155)

var vaultMattersHoldsUpdate* = Call_VaultMattersHoldsUpdate_579134(
    name: "vaultMattersHoldsUpdate", meth: HttpMethod.HttpPut,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsUpdate_579135, base: "/",
    url: url_VaultMattersHoldsUpdate_579136, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsGet_579113 = ref object of OpenApiRestCall_578348
proc url_VaultMattersHoldsGet_579115(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "holdId" in path, "`holdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/holds/"),
               (kind: VariableSegment, value: "holdId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersHoldsGet_579114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a hold by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   holdId: JString (required)
  ##         : The hold ID.
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `holdId` field"
  var valid_579116 = path.getOrDefault("holdId")
  valid_579116 = validateParameter(valid_579116, JString, required = true,
                                 default = nil)
  if valid_579116 != nil:
    section.add "holdId", valid_579116
  var valid_579117 = path.getOrDefault("matterId")
  valid_579117 = validateParameter(valid_579117, JString, required = true,
                                 default = nil)
  if valid_579117 != nil:
    section.add "matterId", valid_579117
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
  ##   view: JString
  ##       : Specifies which parts of the Hold to return.
  section = newJObject()
  var valid_579118 = query.getOrDefault("key")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "key", valid_579118
  var valid_579119 = query.getOrDefault("prettyPrint")
  valid_579119 = validateParameter(valid_579119, JBool, required = false,
                                 default = newJBool(true))
  if valid_579119 != nil:
    section.add "prettyPrint", valid_579119
  var valid_579120 = query.getOrDefault("oauth_token")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "oauth_token", valid_579120
  var valid_579121 = query.getOrDefault("$.xgafv")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = newJString("1"))
  if valid_579121 != nil:
    section.add "$.xgafv", valid_579121
  var valid_579122 = query.getOrDefault("alt")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("json"))
  if valid_579122 != nil:
    section.add "alt", valid_579122
  var valid_579123 = query.getOrDefault("uploadType")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "uploadType", valid_579123
  var valid_579124 = query.getOrDefault("quotaUser")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "quotaUser", valid_579124
  var valid_579125 = query.getOrDefault("callback")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "callback", valid_579125
  var valid_579126 = query.getOrDefault("fields")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "fields", valid_579126
  var valid_579127 = query.getOrDefault("access_token")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "access_token", valid_579127
  var valid_579128 = query.getOrDefault("upload_protocol")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "upload_protocol", valid_579128
  var valid_579129 = query.getOrDefault("view")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = newJString("HOLD_VIEW_UNSPECIFIED"))
  if valid_579129 != nil:
    section.add "view", valid_579129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579130: Call_VaultMattersHoldsGet_579113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a hold by ID.
  ## 
  let valid = call_579130.validator(path, query, header, formData, body)
  let scheme = call_579130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579130.url(scheme.get, call_579130.host, call_579130.base,
                         call_579130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579130, url, valid)

proc call*(call_579131: Call_VaultMattersHoldsGet_579113; holdId: string;
          matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          view: string = "HOLD_VIEW_UNSPECIFIED"): Recallable =
  ## vaultMattersHoldsGet
  ## Gets a hold by ID.
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
  ##   holdId: string (required)
  ##         : The hold ID.
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Specifies which parts of the Hold to return.
  var path_579132 = newJObject()
  var query_579133 = newJObject()
  add(query_579133, "key", newJString(key))
  add(query_579133, "prettyPrint", newJBool(prettyPrint))
  add(query_579133, "oauth_token", newJString(oauthToken))
  add(query_579133, "$.xgafv", newJString(Xgafv))
  add(query_579133, "alt", newJString(alt))
  add(query_579133, "uploadType", newJString(uploadType))
  add(query_579133, "quotaUser", newJString(quotaUser))
  add(path_579132, "holdId", newJString(holdId))
  add(query_579133, "callback", newJString(callback))
  add(path_579132, "matterId", newJString(matterId))
  add(query_579133, "fields", newJString(fields))
  add(query_579133, "access_token", newJString(accessToken))
  add(query_579133, "upload_protocol", newJString(uploadProtocol))
  add(query_579133, "view", newJString(view))
  result = call_579131.call(path_579132, query_579133, nil, nil, nil)

var vaultMattersHoldsGet* = Call_VaultMattersHoldsGet_579113(
    name: "vaultMattersHoldsGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsGet_579114, base: "/",
    url: url_VaultMattersHoldsGet_579115, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsDelete_579156 = ref object of OpenApiRestCall_578348
proc url_VaultMattersHoldsDelete_579158(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "holdId" in path, "`holdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/holds/"),
               (kind: VariableSegment, value: "holdId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersHoldsDelete_579157(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a hold by ID. This will release any HeldAccounts on this Hold.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   holdId: JString (required)
  ##         : The hold ID.
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `holdId` field"
  var valid_579159 = path.getOrDefault("holdId")
  valid_579159 = validateParameter(valid_579159, JString, required = true,
                                 default = nil)
  if valid_579159 != nil:
    section.add "holdId", valid_579159
  var valid_579160 = path.getOrDefault("matterId")
  valid_579160 = validateParameter(valid_579160, JString, required = true,
                                 default = nil)
  if valid_579160 != nil:
    section.add "matterId", valid_579160
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
  var valid_579161 = query.getOrDefault("key")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "key", valid_579161
  var valid_579162 = query.getOrDefault("prettyPrint")
  valid_579162 = validateParameter(valid_579162, JBool, required = false,
                                 default = newJBool(true))
  if valid_579162 != nil:
    section.add "prettyPrint", valid_579162
  var valid_579163 = query.getOrDefault("oauth_token")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "oauth_token", valid_579163
  var valid_579164 = query.getOrDefault("$.xgafv")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = newJString("1"))
  if valid_579164 != nil:
    section.add "$.xgafv", valid_579164
  var valid_579165 = query.getOrDefault("alt")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = newJString("json"))
  if valid_579165 != nil:
    section.add "alt", valid_579165
  var valid_579166 = query.getOrDefault("uploadType")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "uploadType", valid_579166
  var valid_579167 = query.getOrDefault("quotaUser")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "quotaUser", valid_579167
  var valid_579168 = query.getOrDefault("callback")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "callback", valid_579168
  var valid_579169 = query.getOrDefault("fields")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "fields", valid_579169
  var valid_579170 = query.getOrDefault("access_token")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "access_token", valid_579170
  var valid_579171 = query.getOrDefault("upload_protocol")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "upload_protocol", valid_579171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579172: Call_VaultMattersHoldsDelete_579156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a hold by ID. This will release any HeldAccounts on this Hold.
  ## 
  let valid = call_579172.validator(path, query, header, formData, body)
  let scheme = call_579172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579172.url(scheme.get, call_579172.host, call_579172.base,
                         call_579172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579172, url, valid)

proc call*(call_579173: Call_VaultMattersHoldsDelete_579156; holdId: string;
          matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersHoldsDelete
  ## Removes a hold by ID. This will release any HeldAccounts on this Hold.
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
  ##   holdId: string (required)
  ##         : The hold ID.
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579174 = newJObject()
  var query_579175 = newJObject()
  add(query_579175, "key", newJString(key))
  add(query_579175, "prettyPrint", newJBool(prettyPrint))
  add(query_579175, "oauth_token", newJString(oauthToken))
  add(query_579175, "$.xgafv", newJString(Xgafv))
  add(query_579175, "alt", newJString(alt))
  add(query_579175, "uploadType", newJString(uploadType))
  add(query_579175, "quotaUser", newJString(quotaUser))
  add(path_579174, "holdId", newJString(holdId))
  add(query_579175, "callback", newJString(callback))
  add(path_579174, "matterId", newJString(matterId))
  add(query_579175, "fields", newJString(fields))
  add(query_579175, "access_token", newJString(accessToken))
  add(query_579175, "upload_protocol", newJString(uploadProtocol))
  result = call_579173.call(path_579174, query_579175, nil, nil, nil)

var vaultMattersHoldsDelete* = Call_VaultMattersHoldsDelete_579156(
    name: "vaultMattersHoldsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsDelete_579157, base: "/",
    url: url_VaultMattersHoldsDelete_579158, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsCreate_579196 = ref object of OpenApiRestCall_578348
proc url_VaultMattersHoldsAccountsCreate_579198(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "holdId" in path, "`holdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/holds/"),
               (kind: VariableSegment, value: "holdId"),
               (kind: ConstantSegment, value: "/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersHoldsAccountsCreate_579197(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a HeldAccount to a hold. Accounts can only be added to a hold that
  ## has no held_org_unit set. Attempting to add an account to an OU-based
  ## hold will result in an error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   holdId: JString (required)
  ##         : The hold ID.
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `holdId` field"
  var valid_579199 = path.getOrDefault("holdId")
  valid_579199 = validateParameter(valid_579199, JString, required = true,
                                 default = nil)
  if valid_579199 != nil:
    section.add "holdId", valid_579199
  var valid_579200 = path.getOrDefault("matterId")
  valid_579200 = validateParameter(valid_579200, JString, required = true,
                                 default = nil)
  if valid_579200 != nil:
    section.add "matterId", valid_579200
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
  var valid_579201 = query.getOrDefault("key")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "key", valid_579201
  var valid_579202 = query.getOrDefault("prettyPrint")
  valid_579202 = validateParameter(valid_579202, JBool, required = false,
                                 default = newJBool(true))
  if valid_579202 != nil:
    section.add "prettyPrint", valid_579202
  var valid_579203 = query.getOrDefault("oauth_token")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "oauth_token", valid_579203
  var valid_579204 = query.getOrDefault("$.xgafv")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = newJString("1"))
  if valid_579204 != nil:
    section.add "$.xgafv", valid_579204
  var valid_579205 = query.getOrDefault("alt")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = newJString("json"))
  if valid_579205 != nil:
    section.add "alt", valid_579205
  var valid_579206 = query.getOrDefault("uploadType")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "uploadType", valid_579206
  var valid_579207 = query.getOrDefault("quotaUser")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "quotaUser", valid_579207
  var valid_579208 = query.getOrDefault("callback")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "callback", valid_579208
  var valid_579209 = query.getOrDefault("fields")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "fields", valid_579209
  var valid_579210 = query.getOrDefault("access_token")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "access_token", valid_579210
  var valid_579211 = query.getOrDefault("upload_protocol")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "upload_protocol", valid_579211
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

proc call*(call_579213: Call_VaultMattersHoldsAccountsCreate_579196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a HeldAccount to a hold. Accounts can only be added to a hold that
  ## has no held_org_unit set. Attempting to add an account to an OU-based
  ## hold will result in an error.
  ## 
  let valid = call_579213.validator(path, query, header, formData, body)
  let scheme = call_579213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579213.url(scheme.get, call_579213.host, call_579213.base,
                         call_579213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579213, url, valid)

proc call*(call_579214: Call_VaultMattersHoldsAccountsCreate_579196;
          holdId: string; matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersHoldsAccountsCreate
  ## Adds a HeldAccount to a hold. Accounts can only be added to a hold that
  ## has no held_org_unit set. Attempting to add an account to an OU-based
  ## hold will result in an error.
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
  ##   holdId: string (required)
  ##         : The hold ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579215 = newJObject()
  var query_579216 = newJObject()
  var body_579217 = newJObject()
  add(query_579216, "key", newJString(key))
  add(query_579216, "prettyPrint", newJBool(prettyPrint))
  add(query_579216, "oauth_token", newJString(oauthToken))
  add(query_579216, "$.xgafv", newJString(Xgafv))
  add(query_579216, "alt", newJString(alt))
  add(query_579216, "uploadType", newJString(uploadType))
  add(query_579216, "quotaUser", newJString(quotaUser))
  add(path_579215, "holdId", newJString(holdId))
  if body != nil:
    body_579217 = body
  add(query_579216, "callback", newJString(callback))
  add(path_579215, "matterId", newJString(matterId))
  add(query_579216, "fields", newJString(fields))
  add(query_579216, "access_token", newJString(accessToken))
  add(query_579216, "upload_protocol", newJString(uploadProtocol))
  result = call_579214.call(path_579215, query_579216, nil, nil, body_579217)

var vaultMattersHoldsAccountsCreate* = Call_VaultMattersHoldsAccountsCreate_579196(
    name: "vaultMattersHoldsAccountsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts",
    validator: validate_VaultMattersHoldsAccountsCreate_579197, base: "/",
    url: url_VaultMattersHoldsAccountsCreate_579198, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsList_579176 = ref object of OpenApiRestCall_578348
proc url_VaultMattersHoldsAccountsList_579178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "holdId" in path, "`holdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/holds/"),
               (kind: VariableSegment, value: "holdId"),
               (kind: ConstantSegment, value: "/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersHoldsAccountsList_579177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists HeldAccounts for a hold. This will only list individually specified
  ## held accounts. If the hold is on an OU, then use
  ## <a href="https://developers.google.com/admin-sdk/">Admin SDK</a>
  ## to enumerate its members.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   holdId: JString (required)
  ##         : The hold ID.
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `holdId` field"
  var valid_579179 = path.getOrDefault("holdId")
  valid_579179 = validateParameter(valid_579179, JString, required = true,
                                 default = nil)
  if valid_579179 != nil:
    section.add "holdId", valid_579179
  var valid_579180 = path.getOrDefault("matterId")
  valid_579180 = validateParameter(valid_579180, JString, required = true,
                                 default = nil)
  if valid_579180 != nil:
    section.add "matterId", valid_579180
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
  var valid_579181 = query.getOrDefault("key")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "key", valid_579181
  var valid_579182 = query.getOrDefault("prettyPrint")
  valid_579182 = validateParameter(valid_579182, JBool, required = false,
                                 default = newJBool(true))
  if valid_579182 != nil:
    section.add "prettyPrint", valid_579182
  var valid_579183 = query.getOrDefault("oauth_token")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "oauth_token", valid_579183
  var valid_579184 = query.getOrDefault("$.xgafv")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = newJString("1"))
  if valid_579184 != nil:
    section.add "$.xgafv", valid_579184
  var valid_579185 = query.getOrDefault("alt")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = newJString("json"))
  if valid_579185 != nil:
    section.add "alt", valid_579185
  var valid_579186 = query.getOrDefault("uploadType")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "uploadType", valid_579186
  var valid_579187 = query.getOrDefault("quotaUser")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "quotaUser", valid_579187
  var valid_579188 = query.getOrDefault("callback")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "callback", valid_579188
  var valid_579189 = query.getOrDefault("fields")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "fields", valid_579189
  var valid_579190 = query.getOrDefault("access_token")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "access_token", valid_579190
  var valid_579191 = query.getOrDefault("upload_protocol")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "upload_protocol", valid_579191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579192: Call_VaultMattersHoldsAccountsList_579176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists HeldAccounts for a hold. This will only list individually specified
  ## held accounts. If the hold is on an OU, then use
  ## <a href="https://developers.google.com/admin-sdk/">Admin SDK</a>
  ## to enumerate its members.
  ## 
  let valid = call_579192.validator(path, query, header, formData, body)
  let scheme = call_579192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579192.url(scheme.get, call_579192.host, call_579192.base,
                         call_579192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579192, url, valid)

proc call*(call_579193: Call_VaultMattersHoldsAccountsList_579176; holdId: string;
          matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersHoldsAccountsList
  ## Lists HeldAccounts for a hold. This will only list individually specified
  ## held accounts. If the hold is on an OU, then use
  ## <a href="https://developers.google.com/admin-sdk/">Admin SDK</a>
  ## to enumerate its members.
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
  ##   holdId: string (required)
  ##         : The hold ID.
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579194 = newJObject()
  var query_579195 = newJObject()
  add(query_579195, "key", newJString(key))
  add(query_579195, "prettyPrint", newJBool(prettyPrint))
  add(query_579195, "oauth_token", newJString(oauthToken))
  add(query_579195, "$.xgafv", newJString(Xgafv))
  add(query_579195, "alt", newJString(alt))
  add(query_579195, "uploadType", newJString(uploadType))
  add(query_579195, "quotaUser", newJString(quotaUser))
  add(path_579194, "holdId", newJString(holdId))
  add(query_579195, "callback", newJString(callback))
  add(path_579194, "matterId", newJString(matterId))
  add(query_579195, "fields", newJString(fields))
  add(query_579195, "access_token", newJString(accessToken))
  add(query_579195, "upload_protocol", newJString(uploadProtocol))
  result = call_579193.call(path_579194, query_579195, nil, nil, nil)

var vaultMattersHoldsAccountsList* = Call_VaultMattersHoldsAccountsList_579176(
    name: "vaultMattersHoldsAccountsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts",
    validator: validate_VaultMattersHoldsAccountsList_579177, base: "/",
    url: url_VaultMattersHoldsAccountsList_579178, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsDelete_579218 = ref object of OpenApiRestCall_578348
proc url_VaultMattersHoldsAccountsDelete_579220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "holdId" in path, "`holdId` is a required path parameter"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/holds/"),
               (kind: VariableSegment, value: "holdId"),
               (kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersHoldsAccountsDelete_579219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a HeldAccount from a hold. If this request leaves the hold with
  ## no held accounts, the hold will not apply to any accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   holdId: JString (required)
  ##         : The hold ID.
  ##   accountId: JString (required)
  ##            : The ID of the account to remove from the hold.
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `holdId` field"
  var valid_579221 = path.getOrDefault("holdId")
  valid_579221 = validateParameter(valid_579221, JString, required = true,
                                 default = nil)
  if valid_579221 != nil:
    section.add "holdId", valid_579221
  var valid_579222 = path.getOrDefault("accountId")
  valid_579222 = validateParameter(valid_579222, JString, required = true,
                                 default = nil)
  if valid_579222 != nil:
    section.add "accountId", valid_579222
  var valid_579223 = path.getOrDefault("matterId")
  valid_579223 = validateParameter(valid_579223, JString, required = true,
                                 default = nil)
  if valid_579223 != nil:
    section.add "matterId", valid_579223
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
  var valid_579224 = query.getOrDefault("key")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "key", valid_579224
  var valid_579225 = query.getOrDefault("prettyPrint")
  valid_579225 = validateParameter(valid_579225, JBool, required = false,
                                 default = newJBool(true))
  if valid_579225 != nil:
    section.add "prettyPrint", valid_579225
  var valid_579226 = query.getOrDefault("oauth_token")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "oauth_token", valid_579226
  var valid_579227 = query.getOrDefault("$.xgafv")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = newJString("1"))
  if valid_579227 != nil:
    section.add "$.xgafv", valid_579227
  var valid_579228 = query.getOrDefault("alt")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = newJString("json"))
  if valid_579228 != nil:
    section.add "alt", valid_579228
  var valid_579229 = query.getOrDefault("uploadType")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "uploadType", valid_579229
  var valid_579230 = query.getOrDefault("quotaUser")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "quotaUser", valid_579230
  var valid_579231 = query.getOrDefault("callback")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "callback", valid_579231
  var valid_579232 = query.getOrDefault("fields")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "fields", valid_579232
  var valid_579233 = query.getOrDefault("access_token")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "access_token", valid_579233
  var valid_579234 = query.getOrDefault("upload_protocol")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "upload_protocol", valid_579234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579235: Call_VaultMattersHoldsAccountsDelete_579218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a HeldAccount from a hold. If this request leaves the hold with
  ## no held accounts, the hold will not apply to any accounts.
  ## 
  let valid = call_579235.validator(path, query, header, formData, body)
  let scheme = call_579235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579235.url(scheme.get, call_579235.host, call_579235.base,
                         call_579235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579235, url, valid)

proc call*(call_579236: Call_VaultMattersHoldsAccountsDelete_579218;
          holdId: string; accountId: string; matterId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersHoldsAccountsDelete
  ## Removes a HeldAccount from a hold. If this request leaves the hold with
  ## no held accounts, the hold will not apply to any accounts.
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
  ##   holdId: string (required)
  ##         : The hold ID.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : The ID of the account to remove from the hold.
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579237 = newJObject()
  var query_579238 = newJObject()
  add(query_579238, "key", newJString(key))
  add(query_579238, "prettyPrint", newJBool(prettyPrint))
  add(query_579238, "oauth_token", newJString(oauthToken))
  add(query_579238, "$.xgafv", newJString(Xgafv))
  add(query_579238, "alt", newJString(alt))
  add(query_579238, "uploadType", newJString(uploadType))
  add(query_579238, "quotaUser", newJString(quotaUser))
  add(path_579237, "holdId", newJString(holdId))
  add(query_579238, "callback", newJString(callback))
  add(path_579237, "accountId", newJString(accountId))
  add(path_579237, "matterId", newJString(matterId))
  add(query_579238, "fields", newJString(fields))
  add(query_579238, "access_token", newJString(accessToken))
  add(query_579238, "upload_protocol", newJString(uploadProtocol))
  result = call_579236.call(path_579237, query_579238, nil, nil, nil)

var vaultMattersHoldsAccountsDelete* = Call_VaultMattersHoldsAccountsDelete_579218(
    name: "vaultMattersHoldsAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts/{accountId}",
    validator: validate_VaultMattersHoldsAccountsDelete_579219, base: "/",
    url: url_VaultMattersHoldsAccountsDelete_579220, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAddHeldAccounts_579239 = ref object of OpenApiRestCall_578348
proc url_VaultMattersHoldsAddHeldAccounts_579241(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "holdId" in path, "`holdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/holds/"),
               (kind: VariableSegment, value: "holdId"),
               (kind: ConstantSegment, value: ":addHeldAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersHoldsAddHeldAccounts_579240(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds HeldAccounts to a hold. Returns a list of accounts that have been
  ## successfully added. Accounts can only be added to an existing account-based
  ## hold.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   holdId: JString (required)
  ##         : The hold ID.
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `holdId` field"
  var valid_579242 = path.getOrDefault("holdId")
  valid_579242 = validateParameter(valid_579242, JString, required = true,
                                 default = nil)
  if valid_579242 != nil:
    section.add "holdId", valid_579242
  var valid_579243 = path.getOrDefault("matterId")
  valid_579243 = validateParameter(valid_579243, JString, required = true,
                                 default = nil)
  if valid_579243 != nil:
    section.add "matterId", valid_579243
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
  var valid_579244 = query.getOrDefault("key")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "key", valid_579244
  var valid_579245 = query.getOrDefault("prettyPrint")
  valid_579245 = validateParameter(valid_579245, JBool, required = false,
                                 default = newJBool(true))
  if valid_579245 != nil:
    section.add "prettyPrint", valid_579245
  var valid_579246 = query.getOrDefault("oauth_token")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "oauth_token", valid_579246
  var valid_579247 = query.getOrDefault("$.xgafv")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = newJString("1"))
  if valid_579247 != nil:
    section.add "$.xgafv", valid_579247
  var valid_579248 = query.getOrDefault("alt")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = newJString("json"))
  if valid_579248 != nil:
    section.add "alt", valid_579248
  var valid_579249 = query.getOrDefault("uploadType")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "uploadType", valid_579249
  var valid_579250 = query.getOrDefault("quotaUser")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "quotaUser", valid_579250
  var valid_579251 = query.getOrDefault("callback")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "callback", valid_579251
  var valid_579252 = query.getOrDefault("fields")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "fields", valid_579252
  var valid_579253 = query.getOrDefault("access_token")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "access_token", valid_579253
  var valid_579254 = query.getOrDefault("upload_protocol")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "upload_protocol", valid_579254
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

proc call*(call_579256: Call_VaultMattersHoldsAddHeldAccounts_579239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds HeldAccounts to a hold. Returns a list of accounts that have been
  ## successfully added. Accounts can only be added to an existing account-based
  ## hold.
  ## 
  let valid = call_579256.validator(path, query, header, formData, body)
  let scheme = call_579256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579256.url(scheme.get, call_579256.host, call_579256.base,
                         call_579256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579256, url, valid)

proc call*(call_579257: Call_VaultMattersHoldsAddHeldAccounts_579239;
          holdId: string; matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersHoldsAddHeldAccounts
  ## Adds HeldAccounts to a hold. Returns a list of accounts that have been
  ## successfully added. Accounts can only be added to an existing account-based
  ## hold.
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
  ##   holdId: string (required)
  ##         : The hold ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579258 = newJObject()
  var query_579259 = newJObject()
  var body_579260 = newJObject()
  add(query_579259, "key", newJString(key))
  add(query_579259, "prettyPrint", newJBool(prettyPrint))
  add(query_579259, "oauth_token", newJString(oauthToken))
  add(query_579259, "$.xgafv", newJString(Xgafv))
  add(query_579259, "alt", newJString(alt))
  add(query_579259, "uploadType", newJString(uploadType))
  add(query_579259, "quotaUser", newJString(quotaUser))
  add(path_579258, "holdId", newJString(holdId))
  if body != nil:
    body_579260 = body
  add(query_579259, "callback", newJString(callback))
  add(path_579258, "matterId", newJString(matterId))
  add(query_579259, "fields", newJString(fields))
  add(query_579259, "access_token", newJString(accessToken))
  add(query_579259, "upload_protocol", newJString(uploadProtocol))
  result = call_579257.call(path_579258, query_579259, nil, nil, body_579260)

var vaultMattersHoldsAddHeldAccounts* = Call_VaultMattersHoldsAddHeldAccounts_579239(
    name: "vaultMattersHoldsAddHeldAccounts", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}:addHeldAccounts",
    validator: validate_VaultMattersHoldsAddHeldAccounts_579240, base: "/",
    url: url_VaultMattersHoldsAddHeldAccounts_579241, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsRemoveHeldAccounts_579261 = ref object of OpenApiRestCall_578348
proc url_VaultMattersHoldsRemoveHeldAccounts_579263(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "holdId" in path, "`holdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/holds/"),
               (kind: VariableSegment, value: "holdId"),
               (kind: ConstantSegment, value: ":removeHeldAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersHoldsRemoveHeldAccounts_579262(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes HeldAccounts from a hold. Returns a list of statuses in the same
  ## order as the request. If this request leaves the hold with no held
  ## accounts, the hold will not apply to any accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   holdId: JString (required)
  ##         : The hold ID.
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `holdId` field"
  var valid_579264 = path.getOrDefault("holdId")
  valid_579264 = validateParameter(valid_579264, JString, required = true,
                                 default = nil)
  if valid_579264 != nil:
    section.add "holdId", valid_579264
  var valid_579265 = path.getOrDefault("matterId")
  valid_579265 = validateParameter(valid_579265, JString, required = true,
                                 default = nil)
  if valid_579265 != nil:
    section.add "matterId", valid_579265
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
  var valid_579266 = query.getOrDefault("key")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "key", valid_579266
  var valid_579267 = query.getOrDefault("prettyPrint")
  valid_579267 = validateParameter(valid_579267, JBool, required = false,
                                 default = newJBool(true))
  if valid_579267 != nil:
    section.add "prettyPrint", valid_579267
  var valid_579268 = query.getOrDefault("oauth_token")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "oauth_token", valid_579268
  var valid_579269 = query.getOrDefault("$.xgafv")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = newJString("1"))
  if valid_579269 != nil:
    section.add "$.xgafv", valid_579269
  var valid_579270 = query.getOrDefault("alt")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = newJString("json"))
  if valid_579270 != nil:
    section.add "alt", valid_579270
  var valid_579271 = query.getOrDefault("uploadType")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "uploadType", valid_579271
  var valid_579272 = query.getOrDefault("quotaUser")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "quotaUser", valid_579272
  var valid_579273 = query.getOrDefault("callback")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "callback", valid_579273
  var valid_579274 = query.getOrDefault("fields")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "fields", valid_579274
  var valid_579275 = query.getOrDefault("access_token")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "access_token", valid_579275
  var valid_579276 = query.getOrDefault("upload_protocol")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "upload_protocol", valid_579276
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

proc call*(call_579278: Call_VaultMattersHoldsRemoveHeldAccounts_579261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes HeldAccounts from a hold. Returns a list of statuses in the same
  ## order as the request. If this request leaves the hold with no held
  ## accounts, the hold will not apply to any accounts.
  ## 
  let valid = call_579278.validator(path, query, header, formData, body)
  let scheme = call_579278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579278.url(scheme.get, call_579278.host, call_579278.base,
                         call_579278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579278, url, valid)

proc call*(call_579279: Call_VaultMattersHoldsRemoveHeldAccounts_579261;
          holdId: string; matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersHoldsRemoveHeldAccounts
  ## Removes HeldAccounts from a hold. Returns a list of statuses in the same
  ## order as the request. If this request leaves the hold with no held
  ## accounts, the hold will not apply to any accounts.
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
  ##   holdId: string (required)
  ##         : The hold ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579280 = newJObject()
  var query_579281 = newJObject()
  var body_579282 = newJObject()
  add(query_579281, "key", newJString(key))
  add(query_579281, "prettyPrint", newJBool(prettyPrint))
  add(query_579281, "oauth_token", newJString(oauthToken))
  add(query_579281, "$.xgafv", newJString(Xgafv))
  add(query_579281, "alt", newJString(alt))
  add(query_579281, "uploadType", newJString(uploadType))
  add(query_579281, "quotaUser", newJString(quotaUser))
  add(path_579280, "holdId", newJString(holdId))
  if body != nil:
    body_579282 = body
  add(query_579281, "callback", newJString(callback))
  add(path_579280, "matterId", newJString(matterId))
  add(query_579281, "fields", newJString(fields))
  add(query_579281, "access_token", newJString(accessToken))
  add(query_579281, "upload_protocol", newJString(uploadProtocol))
  result = call_579279.call(path_579280, query_579281, nil, nil, body_579282)

var vaultMattersHoldsRemoveHeldAccounts* = Call_VaultMattersHoldsRemoveHeldAccounts_579261(
    name: "vaultMattersHoldsRemoveHeldAccounts", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}:removeHeldAccounts",
    validator: validate_VaultMattersHoldsRemoveHeldAccounts_579262, base: "/",
    url: url_VaultMattersHoldsRemoveHeldAccounts_579263, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesCreate_579304 = ref object of OpenApiRestCall_578348
proc url_VaultMattersSavedQueriesCreate_579306(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/savedQueries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersSavedQueriesCreate_579305(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a saved query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_579307 = path.getOrDefault("matterId")
  valid_579307 = validateParameter(valid_579307, JString, required = true,
                                 default = nil)
  if valid_579307 != nil:
    section.add "matterId", valid_579307
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
  var valid_579308 = query.getOrDefault("key")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "key", valid_579308
  var valid_579309 = query.getOrDefault("prettyPrint")
  valid_579309 = validateParameter(valid_579309, JBool, required = false,
                                 default = newJBool(true))
  if valid_579309 != nil:
    section.add "prettyPrint", valid_579309
  var valid_579310 = query.getOrDefault("oauth_token")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "oauth_token", valid_579310
  var valid_579311 = query.getOrDefault("$.xgafv")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = newJString("1"))
  if valid_579311 != nil:
    section.add "$.xgafv", valid_579311
  var valid_579312 = query.getOrDefault("alt")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = newJString("json"))
  if valid_579312 != nil:
    section.add "alt", valid_579312
  var valid_579313 = query.getOrDefault("uploadType")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "uploadType", valid_579313
  var valid_579314 = query.getOrDefault("quotaUser")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "quotaUser", valid_579314
  var valid_579315 = query.getOrDefault("callback")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "callback", valid_579315
  var valid_579316 = query.getOrDefault("fields")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "fields", valid_579316
  var valid_579317 = query.getOrDefault("access_token")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "access_token", valid_579317
  var valid_579318 = query.getOrDefault("upload_protocol")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "upload_protocol", valid_579318
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

proc call*(call_579320: Call_VaultMattersSavedQueriesCreate_579304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a saved query.
  ## 
  let valid = call_579320.validator(path, query, header, formData, body)
  let scheme = call_579320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579320.url(scheme.get, call_579320.host, call_579320.base,
                         call_579320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579320, url, valid)

proc call*(call_579321: Call_VaultMattersSavedQueriesCreate_579304;
          matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersSavedQueriesCreate
  ## Creates a saved query.
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
  ##   matterId: string (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579322 = newJObject()
  var query_579323 = newJObject()
  var body_579324 = newJObject()
  add(query_579323, "key", newJString(key))
  add(query_579323, "prettyPrint", newJBool(prettyPrint))
  add(query_579323, "oauth_token", newJString(oauthToken))
  add(query_579323, "$.xgafv", newJString(Xgafv))
  add(query_579323, "alt", newJString(alt))
  add(query_579323, "uploadType", newJString(uploadType))
  add(query_579323, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579324 = body
  add(query_579323, "callback", newJString(callback))
  add(path_579322, "matterId", newJString(matterId))
  add(query_579323, "fields", newJString(fields))
  add(query_579323, "access_token", newJString(accessToken))
  add(query_579323, "upload_protocol", newJString(uploadProtocol))
  result = call_579321.call(path_579322, query_579323, nil, nil, body_579324)

var vaultMattersSavedQueriesCreate* = Call_VaultMattersSavedQueriesCreate_579304(
    name: "vaultMattersSavedQueriesCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/savedQueries",
    validator: validate_VaultMattersSavedQueriesCreate_579305, base: "/",
    url: url_VaultMattersSavedQueriesCreate_579306, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesList_579283 = ref object of OpenApiRestCall_578348
proc url_VaultMattersSavedQueriesList_579285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/savedQueries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersSavedQueriesList_579284(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists saved queries within a matter. An empty page token in
  ## ListSavedQueriesResponse denotes no more saved queries to list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter id of the parent matter for which the saved queries are to be
  ## retrieved.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_579286 = path.getOrDefault("matterId")
  valid_579286 = validateParameter(valid_579286, JString, required = true,
                                 default = nil)
  if valid_579286 != nil:
    section.add "matterId", valid_579286
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
  ##   pageSize: JInt
  ##           : The maximum number of saved queries to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pagination token as returned in the previous response.
  ## An empty token means start from the beginning.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579287 = query.getOrDefault("key")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "key", valid_579287
  var valid_579288 = query.getOrDefault("prettyPrint")
  valid_579288 = validateParameter(valid_579288, JBool, required = false,
                                 default = newJBool(true))
  if valid_579288 != nil:
    section.add "prettyPrint", valid_579288
  var valid_579289 = query.getOrDefault("oauth_token")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "oauth_token", valid_579289
  var valid_579290 = query.getOrDefault("$.xgafv")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = newJString("1"))
  if valid_579290 != nil:
    section.add "$.xgafv", valid_579290
  var valid_579291 = query.getOrDefault("pageSize")
  valid_579291 = validateParameter(valid_579291, JInt, required = false, default = nil)
  if valid_579291 != nil:
    section.add "pageSize", valid_579291
  var valid_579292 = query.getOrDefault("alt")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = newJString("json"))
  if valid_579292 != nil:
    section.add "alt", valid_579292
  var valid_579293 = query.getOrDefault("uploadType")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "uploadType", valid_579293
  var valid_579294 = query.getOrDefault("quotaUser")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "quotaUser", valid_579294
  var valid_579295 = query.getOrDefault("pageToken")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "pageToken", valid_579295
  var valid_579296 = query.getOrDefault("callback")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "callback", valid_579296
  var valid_579297 = query.getOrDefault("fields")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "fields", valid_579297
  var valid_579298 = query.getOrDefault("access_token")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "access_token", valid_579298
  var valid_579299 = query.getOrDefault("upload_protocol")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "upload_protocol", valid_579299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579300: Call_VaultMattersSavedQueriesList_579283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists saved queries within a matter. An empty page token in
  ## ListSavedQueriesResponse denotes no more saved queries to list.
  ## 
  let valid = call_579300.validator(path, query, header, formData, body)
  let scheme = call_579300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579300.url(scheme.get, call_579300.host, call_579300.base,
                         call_579300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579300, url, valid)

proc call*(call_579301: Call_VaultMattersSavedQueriesList_579283; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersSavedQueriesList
  ## Lists saved queries within a matter. An empty page token in
  ## ListSavedQueriesResponse denotes no more saved queries to list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of saved queries to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The pagination token as returned in the previous response.
  ## An empty token means start from the beginning.
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter id of the parent matter for which the saved queries are to be
  ## retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579302 = newJObject()
  var query_579303 = newJObject()
  add(query_579303, "key", newJString(key))
  add(query_579303, "prettyPrint", newJBool(prettyPrint))
  add(query_579303, "oauth_token", newJString(oauthToken))
  add(query_579303, "$.xgafv", newJString(Xgafv))
  add(query_579303, "pageSize", newJInt(pageSize))
  add(query_579303, "alt", newJString(alt))
  add(query_579303, "uploadType", newJString(uploadType))
  add(query_579303, "quotaUser", newJString(quotaUser))
  add(query_579303, "pageToken", newJString(pageToken))
  add(query_579303, "callback", newJString(callback))
  add(path_579302, "matterId", newJString(matterId))
  add(query_579303, "fields", newJString(fields))
  add(query_579303, "access_token", newJString(accessToken))
  add(query_579303, "upload_protocol", newJString(uploadProtocol))
  result = call_579301.call(path_579302, query_579303, nil, nil, nil)

var vaultMattersSavedQueriesList* = Call_VaultMattersSavedQueriesList_579283(
    name: "vaultMattersSavedQueriesList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/savedQueries",
    validator: validate_VaultMattersSavedQueriesList_579284, base: "/",
    url: url_VaultMattersSavedQueriesList_579285, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesGet_579325 = ref object of OpenApiRestCall_578348
proc url_VaultMattersSavedQueriesGet_579327(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "savedQueryId" in path, "`savedQueryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/savedQueries/"),
               (kind: VariableSegment, value: "savedQueryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersSavedQueriesGet_579326(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a saved query by Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedQueryId: JString (required)
  ##               : Id of the saved query to be retrieved.
  ##   matterId: JString (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## retrieved.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedQueryId` field"
  var valid_579328 = path.getOrDefault("savedQueryId")
  valid_579328 = validateParameter(valid_579328, JString, required = true,
                                 default = nil)
  if valid_579328 != nil:
    section.add "savedQueryId", valid_579328
  var valid_579329 = path.getOrDefault("matterId")
  valid_579329 = validateParameter(valid_579329, JString, required = true,
                                 default = nil)
  if valid_579329 != nil:
    section.add "matterId", valid_579329
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
  var valid_579330 = query.getOrDefault("key")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "key", valid_579330
  var valid_579331 = query.getOrDefault("prettyPrint")
  valid_579331 = validateParameter(valid_579331, JBool, required = false,
                                 default = newJBool(true))
  if valid_579331 != nil:
    section.add "prettyPrint", valid_579331
  var valid_579332 = query.getOrDefault("oauth_token")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "oauth_token", valid_579332
  var valid_579333 = query.getOrDefault("$.xgafv")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = newJString("1"))
  if valid_579333 != nil:
    section.add "$.xgafv", valid_579333
  var valid_579334 = query.getOrDefault("alt")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = newJString("json"))
  if valid_579334 != nil:
    section.add "alt", valid_579334
  var valid_579335 = query.getOrDefault("uploadType")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "uploadType", valid_579335
  var valid_579336 = query.getOrDefault("quotaUser")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "quotaUser", valid_579336
  var valid_579337 = query.getOrDefault("callback")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "callback", valid_579337
  var valid_579338 = query.getOrDefault("fields")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "fields", valid_579338
  var valid_579339 = query.getOrDefault("access_token")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "access_token", valid_579339
  var valid_579340 = query.getOrDefault("upload_protocol")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "upload_protocol", valid_579340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579341: Call_VaultMattersSavedQueriesGet_579325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a saved query by Id.
  ## 
  let valid = call_579341.validator(path, query, header, formData, body)
  let scheme = call_579341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579341.url(scheme.get, call_579341.host, call_579341.base,
                         call_579341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579341, url, valid)

proc call*(call_579342: Call_VaultMattersSavedQueriesGet_579325;
          savedQueryId: string; matterId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersSavedQueriesGet
  ## Retrieves a saved query by Id.
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
  ##   savedQueryId: string (required)
  ##               : Id of the saved query to be retrieved.
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579343 = newJObject()
  var query_579344 = newJObject()
  add(query_579344, "key", newJString(key))
  add(query_579344, "prettyPrint", newJBool(prettyPrint))
  add(query_579344, "oauth_token", newJString(oauthToken))
  add(query_579344, "$.xgafv", newJString(Xgafv))
  add(query_579344, "alt", newJString(alt))
  add(query_579344, "uploadType", newJString(uploadType))
  add(query_579344, "quotaUser", newJString(quotaUser))
  add(path_579343, "savedQueryId", newJString(savedQueryId))
  add(query_579344, "callback", newJString(callback))
  add(path_579343, "matterId", newJString(matterId))
  add(query_579344, "fields", newJString(fields))
  add(query_579344, "access_token", newJString(accessToken))
  add(query_579344, "upload_protocol", newJString(uploadProtocol))
  result = call_579342.call(path_579343, query_579344, nil, nil, nil)

var vaultMattersSavedQueriesGet* = Call_VaultMattersSavedQueriesGet_579325(
    name: "vaultMattersSavedQueriesGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/savedQueries/{savedQueryId}",
    validator: validate_VaultMattersSavedQueriesGet_579326, base: "/",
    url: url_VaultMattersSavedQueriesGet_579327, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesDelete_579345 = ref object of OpenApiRestCall_578348
proc url_VaultMattersSavedQueriesDelete_579347(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  assert "savedQueryId" in path, "`savedQueryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: "/savedQueries/"),
               (kind: VariableSegment, value: "savedQueryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersSavedQueriesDelete_579346(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a saved query by Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedQueryId: JString (required)
  ##               : Id of the saved query to be deleted.
  ##   matterId: JString (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedQueryId` field"
  var valid_579348 = path.getOrDefault("savedQueryId")
  valid_579348 = validateParameter(valid_579348, JString, required = true,
                                 default = nil)
  if valid_579348 != nil:
    section.add "savedQueryId", valid_579348
  var valid_579349 = path.getOrDefault("matterId")
  valid_579349 = validateParameter(valid_579349, JString, required = true,
                                 default = nil)
  if valid_579349 != nil:
    section.add "matterId", valid_579349
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
  var valid_579350 = query.getOrDefault("key")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "key", valid_579350
  var valid_579351 = query.getOrDefault("prettyPrint")
  valid_579351 = validateParameter(valid_579351, JBool, required = false,
                                 default = newJBool(true))
  if valid_579351 != nil:
    section.add "prettyPrint", valid_579351
  var valid_579352 = query.getOrDefault("oauth_token")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "oauth_token", valid_579352
  var valid_579353 = query.getOrDefault("$.xgafv")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = newJString("1"))
  if valid_579353 != nil:
    section.add "$.xgafv", valid_579353
  var valid_579354 = query.getOrDefault("alt")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = newJString("json"))
  if valid_579354 != nil:
    section.add "alt", valid_579354
  var valid_579355 = query.getOrDefault("uploadType")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "uploadType", valid_579355
  var valid_579356 = query.getOrDefault("quotaUser")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "quotaUser", valid_579356
  var valid_579357 = query.getOrDefault("callback")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "callback", valid_579357
  var valid_579358 = query.getOrDefault("fields")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "fields", valid_579358
  var valid_579359 = query.getOrDefault("access_token")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "access_token", valid_579359
  var valid_579360 = query.getOrDefault("upload_protocol")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "upload_protocol", valid_579360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579361: Call_VaultMattersSavedQueriesDelete_579345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a saved query by Id.
  ## 
  let valid = call_579361.validator(path, query, header, formData, body)
  let scheme = call_579361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579361.url(scheme.get, call_579361.host, call_579361.base,
                         call_579361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579361, url, valid)

proc call*(call_579362: Call_VaultMattersSavedQueriesDelete_579345;
          savedQueryId: string; matterId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersSavedQueriesDelete
  ## Deletes a saved query by Id.
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
  ##   savedQueryId: string (required)
  ##               : Id of the saved query to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   matterId: string (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579363 = newJObject()
  var query_579364 = newJObject()
  add(query_579364, "key", newJString(key))
  add(query_579364, "prettyPrint", newJBool(prettyPrint))
  add(query_579364, "oauth_token", newJString(oauthToken))
  add(query_579364, "$.xgafv", newJString(Xgafv))
  add(query_579364, "alt", newJString(alt))
  add(query_579364, "uploadType", newJString(uploadType))
  add(query_579364, "quotaUser", newJString(quotaUser))
  add(path_579363, "savedQueryId", newJString(savedQueryId))
  add(query_579364, "callback", newJString(callback))
  add(path_579363, "matterId", newJString(matterId))
  add(query_579364, "fields", newJString(fields))
  add(query_579364, "access_token", newJString(accessToken))
  add(query_579364, "upload_protocol", newJString(uploadProtocol))
  result = call_579362.call(path_579363, query_579364, nil, nil, nil)

var vaultMattersSavedQueriesDelete* = Call_VaultMattersSavedQueriesDelete_579345(
    name: "vaultMattersSavedQueriesDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/savedQueries/{savedQueryId}",
    validator: validate_VaultMattersSavedQueriesDelete_579346, base: "/",
    url: url_VaultMattersSavedQueriesDelete_579347, schemes: {Scheme.Https})
type
  Call_VaultMattersAddPermissions_579365 = ref object of OpenApiRestCall_578348
proc url_VaultMattersAddPermissions_579367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: ":addPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersAddPermissions_579366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds an account as a matter collaborator.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_579368 = path.getOrDefault("matterId")
  valid_579368 = validateParameter(valid_579368, JString, required = true,
                                 default = nil)
  if valid_579368 != nil:
    section.add "matterId", valid_579368
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
  var valid_579369 = query.getOrDefault("key")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "key", valid_579369
  var valid_579370 = query.getOrDefault("prettyPrint")
  valid_579370 = validateParameter(valid_579370, JBool, required = false,
                                 default = newJBool(true))
  if valid_579370 != nil:
    section.add "prettyPrint", valid_579370
  var valid_579371 = query.getOrDefault("oauth_token")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "oauth_token", valid_579371
  var valid_579372 = query.getOrDefault("$.xgafv")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = newJString("1"))
  if valid_579372 != nil:
    section.add "$.xgafv", valid_579372
  var valid_579373 = query.getOrDefault("alt")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = newJString("json"))
  if valid_579373 != nil:
    section.add "alt", valid_579373
  var valid_579374 = query.getOrDefault("uploadType")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "uploadType", valid_579374
  var valid_579375 = query.getOrDefault("quotaUser")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "quotaUser", valid_579375
  var valid_579376 = query.getOrDefault("callback")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "callback", valid_579376
  var valid_579377 = query.getOrDefault("fields")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "fields", valid_579377
  var valid_579378 = query.getOrDefault("access_token")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "access_token", valid_579378
  var valid_579379 = query.getOrDefault("upload_protocol")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "upload_protocol", valid_579379
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

proc call*(call_579381: Call_VaultMattersAddPermissions_579365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an account as a matter collaborator.
  ## 
  let valid = call_579381.validator(path, query, header, formData, body)
  let scheme = call_579381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579381.url(scheme.get, call_579381.host, call_579381.base,
                         call_579381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579381, url, valid)

proc call*(call_579382: Call_VaultMattersAddPermissions_579365; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersAddPermissions
  ## Adds an account as a matter collaborator.
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
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579383 = newJObject()
  var query_579384 = newJObject()
  var body_579385 = newJObject()
  add(query_579384, "key", newJString(key))
  add(query_579384, "prettyPrint", newJBool(prettyPrint))
  add(query_579384, "oauth_token", newJString(oauthToken))
  add(query_579384, "$.xgafv", newJString(Xgafv))
  add(query_579384, "alt", newJString(alt))
  add(query_579384, "uploadType", newJString(uploadType))
  add(query_579384, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579385 = body
  add(query_579384, "callback", newJString(callback))
  add(path_579383, "matterId", newJString(matterId))
  add(query_579384, "fields", newJString(fields))
  add(query_579384, "access_token", newJString(accessToken))
  add(query_579384, "upload_protocol", newJString(uploadProtocol))
  result = call_579382.call(path_579383, query_579384, nil, nil, body_579385)

var vaultMattersAddPermissions* = Call_VaultMattersAddPermissions_579365(
    name: "vaultMattersAddPermissions", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:addPermissions",
    validator: validate_VaultMattersAddPermissions_579366, base: "/",
    url: url_VaultMattersAddPermissions_579367, schemes: {Scheme.Https})
type
  Call_VaultMattersClose_579386 = ref object of OpenApiRestCall_578348
proc url_VaultMattersClose_579388(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: ":close")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersClose_579387(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Closes the specified matter. Returns matter with updated state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_579389 = path.getOrDefault("matterId")
  valid_579389 = validateParameter(valid_579389, JString, required = true,
                                 default = nil)
  if valid_579389 != nil:
    section.add "matterId", valid_579389
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
  var valid_579390 = query.getOrDefault("key")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "key", valid_579390
  var valid_579391 = query.getOrDefault("prettyPrint")
  valid_579391 = validateParameter(valid_579391, JBool, required = false,
                                 default = newJBool(true))
  if valid_579391 != nil:
    section.add "prettyPrint", valid_579391
  var valid_579392 = query.getOrDefault("oauth_token")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "oauth_token", valid_579392
  var valid_579393 = query.getOrDefault("$.xgafv")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = newJString("1"))
  if valid_579393 != nil:
    section.add "$.xgafv", valid_579393
  var valid_579394 = query.getOrDefault("alt")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = newJString("json"))
  if valid_579394 != nil:
    section.add "alt", valid_579394
  var valid_579395 = query.getOrDefault("uploadType")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "uploadType", valid_579395
  var valid_579396 = query.getOrDefault("quotaUser")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "quotaUser", valid_579396
  var valid_579397 = query.getOrDefault("callback")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "callback", valid_579397
  var valid_579398 = query.getOrDefault("fields")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = nil)
  if valid_579398 != nil:
    section.add "fields", valid_579398
  var valid_579399 = query.getOrDefault("access_token")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "access_token", valid_579399
  var valid_579400 = query.getOrDefault("upload_protocol")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "upload_protocol", valid_579400
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

proc call*(call_579402: Call_VaultMattersClose_579386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Closes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_579402.validator(path, query, header, formData, body)
  let scheme = call_579402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579402.url(scheme.get, call_579402.host, call_579402.base,
                         call_579402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579402, url, valid)

proc call*(call_579403: Call_VaultMattersClose_579386; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersClose
  ## Closes the specified matter. Returns matter with updated state.
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
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579404 = newJObject()
  var query_579405 = newJObject()
  var body_579406 = newJObject()
  add(query_579405, "key", newJString(key))
  add(query_579405, "prettyPrint", newJBool(prettyPrint))
  add(query_579405, "oauth_token", newJString(oauthToken))
  add(query_579405, "$.xgafv", newJString(Xgafv))
  add(query_579405, "alt", newJString(alt))
  add(query_579405, "uploadType", newJString(uploadType))
  add(query_579405, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579406 = body
  add(query_579405, "callback", newJString(callback))
  add(path_579404, "matterId", newJString(matterId))
  add(query_579405, "fields", newJString(fields))
  add(query_579405, "access_token", newJString(accessToken))
  add(query_579405, "upload_protocol", newJString(uploadProtocol))
  result = call_579403.call(path_579404, query_579405, nil, nil, body_579406)

var vaultMattersClose* = Call_VaultMattersClose_579386(name: "vaultMattersClose",
    meth: HttpMethod.HttpPost, host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}:close", validator: validate_VaultMattersClose_579387,
    base: "/", url: url_VaultMattersClose_579388, schemes: {Scheme.Https})
type
  Call_VaultMattersRemovePermissions_579407 = ref object of OpenApiRestCall_578348
proc url_VaultMattersRemovePermissions_579409(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: ":removePermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersRemovePermissions_579408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes an account as a matter collaborator.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_579410 = path.getOrDefault("matterId")
  valid_579410 = validateParameter(valid_579410, JString, required = true,
                                 default = nil)
  if valid_579410 != nil:
    section.add "matterId", valid_579410
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
  var valid_579411 = query.getOrDefault("key")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "key", valid_579411
  var valid_579412 = query.getOrDefault("prettyPrint")
  valid_579412 = validateParameter(valid_579412, JBool, required = false,
                                 default = newJBool(true))
  if valid_579412 != nil:
    section.add "prettyPrint", valid_579412
  var valid_579413 = query.getOrDefault("oauth_token")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = nil)
  if valid_579413 != nil:
    section.add "oauth_token", valid_579413
  var valid_579414 = query.getOrDefault("$.xgafv")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = newJString("1"))
  if valid_579414 != nil:
    section.add "$.xgafv", valid_579414
  var valid_579415 = query.getOrDefault("alt")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = newJString("json"))
  if valid_579415 != nil:
    section.add "alt", valid_579415
  var valid_579416 = query.getOrDefault("uploadType")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "uploadType", valid_579416
  var valid_579417 = query.getOrDefault("quotaUser")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "quotaUser", valid_579417
  var valid_579418 = query.getOrDefault("callback")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "callback", valid_579418
  var valid_579419 = query.getOrDefault("fields")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "fields", valid_579419
  var valid_579420 = query.getOrDefault("access_token")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "access_token", valid_579420
  var valid_579421 = query.getOrDefault("upload_protocol")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "upload_protocol", valid_579421
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

proc call*(call_579423: Call_VaultMattersRemovePermissions_579407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an account as a matter collaborator.
  ## 
  let valid = call_579423.validator(path, query, header, formData, body)
  let scheme = call_579423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579423.url(scheme.get, call_579423.host, call_579423.base,
                         call_579423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579423, url, valid)

proc call*(call_579424: Call_VaultMattersRemovePermissions_579407;
          matterId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## vaultMattersRemovePermissions
  ## Removes an account as a matter collaborator.
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
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579425 = newJObject()
  var query_579426 = newJObject()
  var body_579427 = newJObject()
  add(query_579426, "key", newJString(key))
  add(query_579426, "prettyPrint", newJBool(prettyPrint))
  add(query_579426, "oauth_token", newJString(oauthToken))
  add(query_579426, "$.xgafv", newJString(Xgafv))
  add(query_579426, "alt", newJString(alt))
  add(query_579426, "uploadType", newJString(uploadType))
  add(query_579426, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579427 = body
  add(query_579426, "callback", newJString(callback))
  add(path_579425, "matterId", newJString(matterId))
  add(query_579426, "fields", newJString(fields))
  add(query_579426, "access_token", newJString(accessToken))
  add(query_579426, "upload_protocol", newJString(uploadProtocol))
  result = call_579424.call(path_579425, query_579426, nil, nil, body_579427)

var vaultMattersRemovePermissions* = Call_VaultMattersRemovePermissions_579407(
    name: "vaultMattersRemovePermissions", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}:removePermissions",
    validator: validate_VaultMattersRemovePermissions_579408, base: "/",
    url: url_VaultMattersRemovePermissions_579409, schemes: {Scheme.Https})
type
  Call_VaultMattersReopen_579428 = ref object of OpenApiRestCall_578348
proc url_VaultMattersReopen_579430(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: ":reopen")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersReopen_579429(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Reopens the specified matter. Returns matter with updated state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_579431 = path.getOrDefault("matterId")
  valid_579431 = validateParameter(valid_579431, JString, required = true,
                                 default = nil)
  if valid_579431 != nil:
    section.add "matterId", valid_579431
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
  var valid_579432 = query.getOrDefault("key")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "key", valid_579432
  var valid_579433 = query.getOrDefault("prettyPrint")
  valid_579433 = validateParameter(valid_579433, JBool, required = false,
                                 default = newJBool(true))
  if valid_579433 != nil:
    section.add "prettyPrint", valid_579433
  var valid_579434 = query.getOrDefault("oauth_token")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "oauth_token", valid_579434
  var valid_579435 = query.getOrDefault("$.xgafv")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = newJString("1"))
  if valid_579435 != nil:
    section.add "$.xgafv", valid_579435
  var valid_579436 = query.getOrDefault("alt")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = newJString("json"))
  if valid_579436 != nil:
    section.add "alt", valid_579436
  var valid_579437 = query.getOrDefault("uploadType")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "uploadType", valid_579437
  var valid_579438 = query.getOrDefault("quotaUser")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "quotaUser", valid_579438
  var valid_579439 = query.getOrDefault("callback")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "callback", valid_579439
  var valid_579440 = query.getOrDefault("fields")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "fields", valid_579440
  var valid_579441 = query.getOrDefault("access_token")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "access_token", valid_579441
  var valid_579442 = query.getOrDefault("upload_protocol")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "upload_protocol", valid_579442
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

proc call*(call_579444: Call_VaultMattersReopen_579428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reopens the specified matter. Returns matter with updated state.
  ## 
  let valid = call_579444.validator(path, query, header, formData, body)
  let scheme = call_579444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579444.url(scheme.get, call_579444.host, call_579444.base,
                         call_579444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579444, url, valid)

proc call*(call_579445: Call_VaultMattersReopen_579428; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersReopen
  ## Reopens the specified matter. Returns matter with updated state.
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
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579446 = newJObject()
  var query_579447 = newJObject()
  var body_579448 = newJObject()
  add(query_579447, "key", newJString(key))
  add(query_579447, "prettyPrint", newJBool(prettyPrint))
  add(query_579447, "oauth_token", newJString(oauthToken))
  add(query_579447, "$.xgafv", newJString(Xgafv))
  add(query_579447, "alt", newJString(alt))
  add(query_579447, "uploadType", newJString(uploadType))
  add(query_579447, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579448 = body
  add(query_579447, "callback", newJString(callback))
  add(path_579446, "matterId", newJString(matterId))
  add(query_579447, "fields", newJString(fields))
  add(query_579447, "access_token", newJString(accessToken))
  add(query_579447, "upload_protocol", newJString(uploadProtocol))
  result = call_579445.call(path_579446, query_579447, nil, nil, body_579448)

var vaultMattersReopen* = Call_VaultMattersReopen_579428(
    name: "vaultMattersReopen", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:reopen",
    validator: validate_VaultMattersReopen_579429, base: "/",
    url: url_VaultMattersReopen_579430, schemes: {Scheme.Https})
type
  Call_VaultMattersUndelete_579449 = ref object of OpenApiRestCall_578348
proc url_VaultMattersUndelete_579451(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersUndelete_579450(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undeletes the specified matter. Returns matter with updated state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_579452 = path.getOrDefault("matterId")
  valid_579452 = validateParameter(valid_579452, JString, required = true,
                                 default = nil)
  if valid_579452 != nil:
    section.add "matterId", valid_579452
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
  var valid_579453 = query.getOrDefault("key")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "key", valid_579453
  var valid_579454 = query.getOrDefault("prettyPrint")
  valid_579454 = validateParameter(valid_579454, JBool, required = false,
                                 default = newJBool(true))
  if valid_579454 != nil:
    section.add "prettyPrint", valid_579454
  var valid_579455 = query.getOrDefault("oauth_token")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = nil)
  if valid_579455 != nil:
    section.add "oauth_token", valid_579455
  var valid_579456 = query.getOrDefault("$.xgafv")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = newJString("1"))
  if valid_579456 != nil:
    section.add "$.xgafv", valid_579456
  var valid_579457 = query.getOrDefault("alt")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = newJString("json"))
  if valid_579457 != nil:
    section.add "alt", valid_579457
  var valid_579458 = query.getOrDefault("uploadType")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "uploadType", valid_579458
  var valid_579459 = query.getOrDefault("quotaUser")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "quotaUser", valid_579459
  var valid_579460 = query.getOrDefault("callback")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "callback", valid_579460
  var valid_579461 = query.getOrDefault("fields")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "fields", valid_579461
  var valid_579462 = query.getOrDefault("access_token")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "access_token", valid_579462
  var valid_579463 = query.getOrDefault("upload_protocol")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "upload_protocol", valid_579463
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

proc call*(call_579465: Call_VaultMattersUndelete_579449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undeletes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_579465.validator(path, query, header, formData, body)
  let scheme = call_579465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579465.url(scheme.get, call_579465.host, call_579465.base,
                         call_579465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579465, url, valid)

proc call*(call_579466: Call_VaultMattersUndelete_579449; matterId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultMattersUndelete
  ## Undeletes the specified matter. Returns matter with updated state.
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
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579467 = newJObject()
  var query_579468 = newJObject()
  var body_579469 = newJObject()
  add(query_579468, "key", newJString(key))
  add(query_579468, "prettyPrint", newJBool(prettyPrint))
  add(query_579468, "oauth_token", newJString(oauthToken))
  add(query_579468, "$.xgafv", newJString(Xgafv))
  add(query_579468, "alt", newJString(alt))
  add(query_579468, "uploadType", newJString(uploadType))
  add(query_579468, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579469 = body
  add(query_579468, "callback", newJString(callback))
  add(path_579467, "matterId", newJString(matterId))
  add(query_579468, "fields", newJString(fields))
  add(query_579468, "access_token", newJString(accessToken))
  add(query_579468, "upload_protocol", newJString(uploadProtocol))
  result = call_579466.call(path_579467, query_579468, nil, nil, body_579469)

var vaultMattersUndelete* = Call_VaultMattersUndelete_579449(
    name: "vaultMattersUndelete", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:undelete",
    validator: validate_VaultMattersUndelete_579450, base: "/",
    url: url_VaultMattersUndelete_579451, schemes: {Scheme.Https})
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
