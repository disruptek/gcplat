
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "vault"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VaultMattersCreate_588995 = ref object of OpenApiRestCall_588450
proc url_VaultMattersCreate_588997(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VaultMattersCreate_588996(path: JsonNode; query: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588998 = query.getOrDefault("upload_protocol")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "upload_protocol", valid_588998
  var valid_588999 = query.getOrDefault("fields")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "fields", valid_588999
  var valid_589000 = query.getOrDefault("quotaUser")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "quotaUser", valid_589000
  var valid_589001 = query.getOrDefault("alt")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = newJString("json"))
  if valid_589001 != nil:
    section.add "alt", valid_589001
  var valid_589002 = query.getOrDefault("oauth_token")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "oauth_token", valid_589002
  var valid_589003 = query.getOrDefault("callback")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "callback", valid_589003
  var valid_589004 = query.getOrDefault("access_token")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "access_token", valid_589004
  var valid_589005 = query.getOrDefault("uploadType")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "uploadType", valid_589005
  var valid_589006 = query.getOrDefault("key")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "key", valid_589006
  var valid_589007 = query.getOrDefault("$.xgafv")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = newJString("1"))
  if valid_589007 != nil:
    section.add "$.xgafv", valid_589007
  var valid_589008 = query.getOrDefault("prettyPrint")
  valid_589008 = validateParameter(valid_589008, JBool, required = false,
                                 default = newJBool(true))
  if valid_589008 != nil:
    section.add "prettyPrint", valid_589008
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

proc call*(call_589010: Call_VaultMattersCreate_588995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new matter with the given name and description. The initial state
  ## is open, and the owner is the method caller. Returns the created matter
  ## with default view.
  ## 
  let valid = call_589010.validator(path, query, header, formData, body)
  let scheme = call_589010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589010.url(scheme.get, call_589010.host, call_589010.base,
                         call_589010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589010, url, valid)

proc call*(call_589011: Call_VaultMattersCreate_588995;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersCreate
  ## Creates a new matter with the given name and description. The initial state
  ## is open, and the owner is the method caller. Returns the created matter
  ## with default view.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589012 = newJObject()
  var body_589013 = newJObject()
  add(query_589012, "upload_protocol", newJString(uploadProtocol))
  add(query_589012, "fields", newJString(fields))
  add(query_589012, "quotaUser", newJString(quotaUser))
  add(query_589012, "alt", newJString(alt))
  add(query_589012, "oauth_token", newJString(oauthToken))
  add(query_589012, "callback", newJString(callback))
  add(query_589012, "access_token", newJString(accessToken))
  add(query_589012, "uploadType", newJString(uploadType))
  add(query_589012, "key", newJString(key))
  add(query_589012, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589013 = body
  add(query_589012, "prettyPrint", newJBool(prettyPrint))
  result = call_589011.call(nil, query_589012, nil, nil, body_589013)

var vaultMattersCreate* = Call_VaultMattersCreate_588995(
    name: "vaultMattersCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters",
    validator: validate_VaultMattersCreate_588996, base: "/",
    url: url_VaultMattersCreate_588997, schemes: {Scheme.Https})
type
  Call_VaultMattersList_588719 = ref object of OpenApiRestCall_588450
proc url_VaultMattersList_588721(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VaultMattersList_588720(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists matters the user has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pagination token as returned in the response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Specifies which parts of the matter to return in response.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The number of matters to return in the response.
  ## Default and maximum are 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   state: JString
  ##        : If set, list only matters with that specific state. The default is listing
  ## matters of all states.
  section = newJObject()
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("pageToken")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "pageToken", valid_588835
  var valid_588836 = query.getOrDefault("quotaUser")
  valid_588836 = validateParameter(valid_588836, JString, required = false,
                                 default = nil)
  if valid_588836 != nil:
    section.add "quotaUser", valid_588836
  var valid_588850 = query.getOrDefault("view")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_588850 != nil:
    section.add "view", valid_588850
  var valid_588851 = query.getOrDefault("alt")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = newJString("json"))
  if valid_588851 != nil:
    section.add "alt", valid_588851
  var valid_588852 = query.getOrDefault("oauth_token")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "oauth_token", valid_588852
  var valid_588853 = query.getOrDefault("callback")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "callback", valid_588853
  var valid_588854 = query.getOrDefault("access_token")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "access_token", valid_588854
  var valid_588855 = query.getOrDefault("uploadType")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "uploadType", valid_588855
  var valid_588856 = query.getOrDefault("key")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "key", valid_588856
  var valid_588857 = query.getOrDefault("$.xgafv")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("1"))
  if valid_588857 != nil:
    section.add "$.xgafv", valid_588857
  var valid_588858 = query.getOrDefault("pageSize")
  valid_588858 = validateParameter(valid_588858, JInt, required = false, default = nil)
  if valid_588858 != nil:
    section.add "pageSize", valid_588858
  var valid_588859 = query.getOrDefault("prettyPrint")
  valid_588859 = validateParameter(valid_588859, JBool, required = false,
                                 default = newJBool(true))
  if valid_588859 != nil:
    section.add "prettyPrint", valid_588859
  var valid_588860 = query.getOrDefault("state")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = newJString("STATE_UNSPECIFIED"))
  if valid_588860 != nil:
    section.add "state", valid_588860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588883: Call_VaultMattersList_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matters the user has access to.
  ## 
  let valid = call_588883.validator(path, query, header, formData, body)
  let scheme = call_588883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588883.url(scheme.get, call_588883.host, call_588883.base,
                         call_588883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588883, url, valid)

proc call*(call_588954: Call_VaultMattersList_588719; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          view: string = "VIEW_UNSPECIFIED"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; state: string = "STATE_UNSPECIFIED"): Recallable =
  ## vaultMattersList
  ## Lists matters the user has access to.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pagination token as returned in the response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Specifies which parts of the matter to return in response.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of matters to return in the response.
  ## Default and maximum are 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   state: string
  ##        : If set, list only matters with that specific state. The default is listing
  ## matters of all states.
  var query_588955 = newJObject()
  add(query_588955, "upload_protocol", newJString(uploadProtocol))
  add(query_588955, "fields", newJString(fields))
  add(query_588955, "pageToken", newJString(pageToken))
  add(query_588955, "quotaUser", newJString(quotaUser))
  add(query_588955, "view", newJString(view))
  add(query_588955, "alt", newJString(alt))
  add(query_588955, "oauth_token", newJString(oauthToken))
  add(query_588955, "callback", newJString(callback))
  add(query_588955, "access_token", newJString(accessToken))
  add(query_588955, "uploadType", newJString(uploadType))
  add(query_588955, "key", newJString(key))
  add(query_588955, "$.xgafv", newJString(Xgafv))
  add(query_588955, "pageSize", newJInt(pageSize))
  add(query_588955, "prettyPrint", newJBool(prettyPrint))
  add(query_588955, "state", newJString(state))
  result = call_588954.call(nil, query_588955, nil, nil, nil)

var vaultMattersList* = Call_VaultMattersList_588719(name: "vaultMattersList",
    meth: HttpMethod.HttpGet, host: "vault.googleapis.com", route: "/v1/matters",
    validator: validate_VaultMattersList_588720, base: "/",
    url: url_VaultMattersList_588721, schemes: {Scheme.Https})
type
  Call_VaultMattersUpdate_589048 = ref object of OpenApiRestCall_588450
proc url_VaultMattersUpdate_589050(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersUpdate_589049(path: JsonNode; query: JsonNode;
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
  var valid_589051 = path.getOrDefault("matterId")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "matterId", valid_589051
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589052 = query.getOrDefault("upload_protocol")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "upload_protocol", valid_589052
  var valid_589053 = query.getOrDefault("fields")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "fields", valid_589053
  var valid_589054 = query.getOrDefault("quotaUser")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "quotaUser", valid_589054
  var valid_589055 = query.getOrDefault("alt")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("json"))
  if valid_589055 != nil:
    section.add "alt", valid_589055
  var valid_589056 = query.getOrDefault("oauth_token")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "oauth_token", valid_589056
  var valid_589057 = query.getOrDefault("callback")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "callback", valid_589057
  var valid_589058 = query.getOrDefault("access_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "access_token", valid_589058
  var valid_589059 = query.getOrDefault("uploadType")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "uploadType", valid_589059
  var valid_589060 = query.getOrDefault("key")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "key", valid_589060
  var valid_589061 = query.getOrDefault("$.xgafv")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = newJString("1"))
  if valid_589061 != nil:
    section.add "$.xgafv", valid_589061
  var valid_589062 = query.getOrDefault("prettyPrint")
  valid_589062 = validateParameter(valid_589062, JBool, required = false,
                                 default = newJBool(true))
  if valid_589062 != nil:
    section.add "prettyPrint", valid_589062
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

proc call*(call_589064: Call_VaultMattersUpdate_589048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified matter.
  ## This updates only the name and description of the matter, identified by
  ## matter id. Changes to any other fields are ignored.
  ## Returns the default view of the matter.
  ## 
  let valid = call_589064.validator(path, query, header, formData, body)
  let scheme = call_589064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589064.url(scheme.get, call_589064.host, call_589064.base,
                         call_589064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589064, url, valid)

proc call*(call_589065: Call_VaultMattersUpdate_589048; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersUpdate
  ## Updates the specified matter.
  ## This updates only the name and description of the matter, identified by
  ## matter id. Changes to any other fields are ignored.
  ## Returns the default view of the matter.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589066 = newJObject()
  var query_589067 = newJObject()
  var body_589068 = newJObject()
  add(query_589067, "upload_protocol", newJString(uploadProtocol))
  add(query_589067, "fields", newJString(fields))
  add(query_589067, "quotaUser", newJString(quotaUser))
  add(query_589067, "alt", newJString(alt))
  add(query_589067, "oauth_token", newJString(oauthToken))
  add(query_589067, "callback", newJString(callback))
  add(query_589067, "access_token", newJString(accessToken))
  add(query_589067, "uploadType", newJString(uploadType))
  add(path_589066, "matterId", newJString(matterId))
  add(query_589067, "key", newJString(key))
  add(query_589067, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589068 = body
  add(query_589067, "prettyPrint", newJBool(prettyPrint))
  result = call_589065.call(path_589066, query_589067, nil, nil, body_589068)

var vaultMattersUpdate* = Call_VaultMattersUpdate_589048(
    name: "vaultMattersUpdate", meth: HttpMethod.HttpPut,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}",
    validator: validate_VaultMattersUpdate_589049, base: "/",
    url: url_VaultMattersUpdate_589050, schemes: {Scheme.Https})
type
  Call_VaultMattersGet_589014 = ref object of OpenApiRestCall_588450
proc url_VaultMattersGet_589016(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersGet_589015(path: JsonNode; query: JsonNode;
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
  var valid_589031 = path.getOrDefault("matterId")
  valid_589031 = validateParameter(valid_589031, JString, required = true,
                                 default = nil)
  if valid_589031 != nil:
    section.add "matterId", valid_589031
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Specifies which parts of the Matter to return in the response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589032 = query.getOrDefault("upload_protocol")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "upload_protocol", valid_589032
  var valid_589033 = query.getOrDefault("fields")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "fields", valid_589033
  var valid_589034 = query.getOrDefault("view")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_589034 != nil:
    section.add "view", valid_589034
  var valid_589035 = query.getOrDefault("quotaUser")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "quotaUser", valid_589035
  var valid_589036 = query.getOrDefault("alt")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = newJString("json"))
  if valid_589036 != nil:
    section.add "alt", valid_589036
  var valid_589037 = query.getOrDefault("oauth_token")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "oauth_token", valid_589037
  var valid_589038 = query.getOrDefault("callback")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "callback", valid_589038
  var valid_589039 = query.getOrDefault("access_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "access_token", valid_589039
  var valid_589040 = query.getOrDefault("uploadType")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "uploadType", valid_589040
  var valid_589041 = query.getOrDefault("key")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "key", valid_589041
  var valid_589042 = query.getOrDefault("$.xgafv")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("1"))
  if valid_589042 != nil:
    section.add "$.xgafv", valid_589042
  var valid_589043 = query.getOrDefault("prettyPrint")
  valid_589043 = validateParameter(valid_589043, JBool, required = false,
                                 default = newJBool(true))
  if valid_589043 != nil:
    section.add "prettyPrint", valid_589043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589044: Call_VaultMattersGet_589014; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified matter.
  ## 
  let valid = call_589044.validator(path, query, header, formData, body)
  let scheme = call_589044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589044.url(scheme.get, call_589044.host, call_589044.base,
                         call_589044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589044, url, valid)

proc call*(call_589045: Call_VaultMattersGet_589014; matterId: string;
          uploadProtocol: string = ""; fields: string = "";
          view: string = "VIEW_UNSPECIFIED"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## vaultMattersGet
  ## Gets the specified matter.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Specifies which parts of the Matter to return in the response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589046 = newJObject()
  var query_589047 = newJObject()
  add(query_589047, "upload_protocol", newJString(uploadProtocol))
  add(query_589047, "fields", newJString(fields))
  add(query_589047, "view", newJString(view))
  add(query_589047, "quotaUser", newJString(quotaUser))
  add(query_589047, "alt", newJString(alt))
  add(query_589047, "oauth_token", newJString(oauthToken))
  add(query_589047, "callback", newJString(callback))
  add(query_589047, "access_token", newJString(accessToken))
  add(query_589047, "uploadType", newJString(uploadType))
  add(path_589046, "matterId", newJString(matterId))
  add(query_589047, "key", newJString(key))
  add(query_589047, "$.xgafv", newJString(Xgafv))
  add(query_589047, "prettyPrint", newJBool(prettyPrint))
  result = call_589045.call(path_589046, query_589047, nil, nil, nil)

var vaultMattersGet* = Call_VaultMattersGet_589014(name: "vaultMattersGet",
    meth: HttpMethod.HttpGet, host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}", validator: validate_VaultMattersGet_589015,
    base: "/", url: url_VaultMattersGet_589016, schemes: {Scheme.Https})
type
  Call_VaultMattersDelete_589069 = ref object of OpenApiRestCall_588450
proc url_VaultMattersDelete_589071(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersDelete_589070(path: JsonNode; query: JsonNode;
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
  var valid_589072 = path.getOrDefault("matterId")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "matterId", valid_589072
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589073 = query.getOrDefault("upload_protocol")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "upload_protocol", valid_589073
  var valid_589074 = query.getOrDefault("fields")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "fields", valid_589074
  var valid_589075 = query.getOrDefault("quotaUser")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "quotaUser", valid_589075
  var valid_589076 = query.getOrDefault("alt")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("json"))
  if valid_589076 != nil:
    section.add "alt", valid_589076
  var valid_589077 = query.getOrDefault("oauth_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "oauth_token", valid_589077
  var valid_589078 = query.getOrDefault("callback")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "callback", valid_589078
  var valid_589079 = query.getOrDefault("access_token")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "access_token", valid_589079
  var valid_589080 = query.getOrDefault("uploadType")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "uploadType", valid_589080
  var valid_589081 = query.getOrDefault("key")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "key", valid_589081
  var valid_589082 = query.getOrDefault("$.xgafv")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = newJString("1"))
  if valid_589082 != nil:
    section.add "$.xgafv", valid_589082
  var valid_589083 = query.getOrDefault("prettyPrint")
  valid_589083 = validateParameter(valid_589083, JBool, required = false,
                                 default = newJBool(true))
  if valid_589083 != nil:
    section.add "prettyPrint", valid_589083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589084: Call_VaultMattersDelete_589069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_589084.validator(path, query, header, formData, body)
  let scheme = call_589084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589084.url(scheme.get, call_589084.host, call_589084.base,
                         call_589084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589084, url, valid)

proc call*(call_589085: Call_VaultMattersDelete_589069; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## vaultMattersDelete
  ## Deletes the specified matter. Returns matter with updated state.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589086 = newJObject()
  var query_589087 = newJObject()
  add(query_589087, "upload_protocol", newJString(uploadProtocol))
  add(query_589087, "fields", newJString(fields))
  add(query_589087, "quotaUser", newJString(quotaUser))
  add(query_589087, "alt", newJString(alt))
  add(query_589087, "oauth_token", newJString(oauthToken))
  add(query_589087, "callback", newJString(callback))
  add(query_589087, "access_token", newJString(accessToken))
  add(query_589087, "uploadType", newJString(uploadType))
  add(path_589086, "matterId", newJString(matterId))
  add(query_589087, "key", newJString(key))
  add(query_589087, "$.xgafv", newJString(Xgafv))
  add(query_589087, "prettyPrint", newJBool(prettyPrint))
  result = call_589085.call(path_589086, query_589087, nil, nil, nil)

var vaultMattersDelete* = Call_VaultMattersDelete_589069(
    name: "vaultMattersDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}",
    validator: validate_VaultMattersDelete_589070, base: "/",
    url: url_VaultMattersDelete_589071, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsCreate_589109 = ref object of OpenApiRestCall_588450
proc url_VaultMattersExportsCreate_589111(protocol: Scheme; host: string;
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

proc validate_VaultMattersExportsCreate_589110(path: JsonNode; query: JsonNode;
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
  var valid_589112 = path.getOrDefault("matterId")
  valid_589112 = validateParameter(valid_589112, JString, required = true,
                                 default = nil)
  if valid_589112 != nil:
    section.add "matterId", valid_589112
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589113 = query.getOrDefault("upload_protocol")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "upload_protocol", valid_589113
  var valid_589114 = query.getOrDefault("fields")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "fields", valid_589114
  var valid_589115 = query.getOrDefault("quotaUser")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "quotaUser", valid_589115
  var valid_589116 = query.getOrDefault("alt")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = newJString("json"))
  if valid_589116 != nil:
    section.add "alt", valid_589116
  var valid_589117 = query.getOrDefault("oauth_token")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "oauth_token", valid_589117
  var valid_589118 = query.getOrDefault("callback")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "callback", valid_589118
  var valid_589119 = query.getOrDefault("access_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "access_token", valid_589119
  var valid_589120 = query.getOrDefault("uploadType")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "uploadType", valid_589120
  var valid_589121 = query.getOrDefault("key")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "key", valid_589121
  var valid_589122 = query.getOrDefault("$.xgafv")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = newJString("1"))
  if valid_589122 != nil:
    section.add "$.xgafv", valid_589122
  var valid_589123 = query.getOrDefault("prettyPrint")
  valid_589123 = validateParameter(valid_589123, JBool, required = false,
                                 default = newJBool(true))
  if valid_589123 != nil:
    section.add "prettyPrint", valid_589123
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

proc call*(call_589125: Call_VaultMattersExportsCreate_589109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an Export.
  ## 
  let valid = call_589125.validator(path, query, header, formData, body)
  let scheme = call_589125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589125.url(scheme.get, call_589125.host, call_589125.base,
                         call_589125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589125, url, valid)

proc call*(call_589126: Call_VaultMattersExportsCreate_589109; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersExportsCreate
  ## Creates an Export.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589127 = newJObject()
  var query_589128 = newJObject()
  var body_589129 = newJObject()
  add(query_589128, "upload_protocol", newJString(uploadProtocol))
  add(query_589128, "fields", newJString(fields))
  add(query_589128, "quotaUser", newJString(quotaUser))
  add(query_589128, "alt", newJString(alt))
  add(query_589128, "oauth_token", newJString(oauthToken))
  add(query_589128, "callback", newJString(callback))
  add(query_589128, "access_token", newJString(accessToken))
  add(query_589128, "uploadType", newJString(uploadType))
  add(path_589127, "matterId", newJString(matterId))
  add(query_589128, "key", newJString(key))
  add(query_589128, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589129 = body
  add(query_589128, "prettyPrint", newJBool(prettyPrint))
  result = call_589126.call(path_589127, query_589128, nil, nil, body_589129)

var vaultMattersExportsCreate* = Call_VaultMattersExportsCreate_589109(
    name: "vaultMattersExportsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/exports",
    validator: validate_VaultMattersExportsCreate_589110, base: "/",
    url: url_VaultMattersExportsCreate_589111, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsList_589088 = ref object of OpenApiRestCall_588450
proc url_VaultMattersExportsList_589090(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersExportsList_589089(path: JsonNode; query: JsonNode;
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
  var valid_589091 = path.getOrDefault("matterId")
  valid_589091 = validateParameter(valid_589091, JString, required = true,
                                 default = nil)
  if valid_589091 != nil:
    section.add "matterId", valid_589091
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pagination token as returned in the response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The number of exports to return in the response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589092 = query.getOrDefault("upload_protocol")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "upload_protocol", valid_589092
  var valid_589093 = query.getOrDefault("fields")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "fields", valid_589093
  var valid_589094 = query.getOrDefault("pageToken")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "pageToken", valid_589094
  var valid_589095 = query.getOrDefault("quotaUser")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "quotaUser", valid_589095
  var valid_589096 = query.getOrDefault("alt")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("json"))
  if valid_589096 != nil:
    section.add "alt", valid_589096
  var valid_589097 = query.getOrDefault("oauth_token")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "oauth_token", valid_589097
  var valid_589098 = query.getOrDefault("callback")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "callback", valid_589098
  var valid_589099 = query.getOrDefault("access_token")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "access_token", valid_589099
  var valid_589100 = query.getOrDefault("uploadType")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "uploadType", valid_589100
  var valid_589101 = query.getOrDefault("key")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "key", valid_589101
  var valid_589102 = query.getOrDefault("$.xgafv")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("1"))
  if valid_589102 != nil:
    section.add "$.xgafv", valid_589102
  var valid_589103 = query.getOrDefault("pageSize")
  valid_589103 = validateParameter(valid_589103, JInt, required = false, default = nil)
  if valid_589103 != nil:
    section.add "pageSize", valid_589103
  var valid_589104 = query.getOrDefault("prettyPrint")
  valid_589104 = validateParameter(valid_589104, JBool, required = false,
                                 default = newJBool(true))
  if valid_589104 != nil:
    section.add "prettyPrint", valid_589104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589105: Call_VaultMattersExportsList_589088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists Exports.
  ## 
  let valid = call_589105.validator(path, query, header, formData, body)
  let scheme = call_589105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589105.url(scheme.get, call_589105.host, call_589105.base,
                         call_589105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589105, url, valid)

proc call*(call_589106: Call_VaultMattersExportsList_589088; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## vaultMattersExportsList
  ## Lists Exports.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pagination token as returned in the response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of exports to return in the response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589107 = newJObject()
  var query_589108 = newJObject()
  add(query_589108, "upload_protocol", newJString(uploadProtocol))
  add(query_589108, "fields", newJString(fields))
  add(query_589108, "pageToken", newJString(pageToken))
  add(query_589108, "quotaUser", newJString(quotaUser))
  add(query_589108, "alt", newJString(alt))
  add(query_589108, "oauth_token", newJString(oauthToken))
  add(query_589108, "callback", newJString(callback))
  add(query_589108, "access_token", newJString(accessToken))
  add(query_589108, "uploadType", newJString(uploadType))
  add(path_589107, "matterId", newJString(matterId))
  add(query_589108, "key", newJString(key))
  add(query_589108, "$.xgafv", newJString(Xgafv))
  add(query_589108, "pageSize", newJInt(pageSize))
  add(query_589108, "prettyPrint", newJBool(prettyPrint))
  result = call_589106.call(path_589107, query_589108, nil, nil, nil)

var vaultMattersExportsList* = Call_VaultMattersExportsList_589088(
    name: "vaultMattersExportsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/exports",
    validator: validate_VaultMattersExportsList_589089, base: "/",
    url: url_VaultMattersExportsList_589090, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsGet_589130 = ref object of OpenApiRestCall_588450
proc url_VaultMattersExportsGet_589132(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersExportsGet_589131(path: JsonNode; query: JsonNode;
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
  var valid_589133 = path.getOrDefault("exportId")
  valid_589133 = validateParameter(valid_589133, JString, required = true,
                                 default = nil)
  if valid_589133 != nil:
    section.add "exportId", valid_589133
  var valid_589134 = path.getOrDefault("matterId")
  valid_589134 = validateParameter(valid_589134, JString, required = true,
                                 default = nil)
  if valid_589134 != nil:
    section.add "matterId", valid_589134
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589135 = query.getOrDefault("upload_protocol")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "upload_protocol", valid_589135
  var valid_589136 = query.getOrDefault("fields")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "fields", valid_589136
  var valid_589137 = query.getOrDefault("quotaUser")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "quotaUser", valid_589137
  var valid_589138 = query.getOrDefault("alt")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = newJString("json"))
  if valid_589138 != nil:
    section.add "alt", valid_589138
  var valid_589139 = query.getOrDefault("oauth_token")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "oauth_token", valid_589139
  var valid_589140 = query.getOrDefault("callback")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "callback", valid_589140
  var valid_589141 = query.getOrDefault("access_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "access_token", valid_589141
  var valid_589142 = query.getOrDefault("uploadType")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "uploadType", valid_589142
  var valid_589143 = query.getOrDefault("key")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "key", valid_589143
  var valid_589144 = query.getOrDefault("$.xgafv")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = newJString("1"))
  if valid_589144 != nil:
    section.add "$.xgafv", valid_589144
  var valid_589145 = query.getOrDefault("prettyPrint")
  valid_589145 = validateParameter(valid_589145, JBool, required = false,
                                 default = newJBool(true))
  if valid_589145 != nil:
    section.add "prettyPrint", valid_589145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589146: Call_VaultMattersExportsGet_589130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an Export.
  ## 
  let valid = call_589146.validator(path, query, header, formData, body)
  let scheme = call_589146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589146.url(scheme.get, call_589146.host, call_589146.base,
                         call_589146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589146, url, valid)

proc call*(call_589147: Call_VaultMattersExportsGet_589130; exportId: string;
          matterId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## vaultMattersExportsGet
  ## Gets an Export.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   exportId: string (required)
  ##           : The export ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589148 = newJObject()
  var query_589149 = newJObject()
  add(query_589149, "upload_protocol", newJString(uploadProtocol))
  add(query_589149, "fields", newJString(fields))
  add(query_589149, "quotaUser", newJString(quotaUser))
  add(query_589149, "alt", newJString(alt))
  add(path_589148, "exportId", newJString(exportId))
  add(query_589149, "oauth_token", newJString(oauthToken))
  add(query_589149, "callback", newJString(callback))
  add(query_589149, "access_token", newJString(accessToken))
  add(query_589149, "uploadType", newJString(uploadType))
  add(path_589148, "matterId", newJString(matterId))
  add(query_589149, "key", newJString(key))
  add(query_589149, "$.xgafv", newJString(Xgafv))
  add(query_589149, "prettyPrint", newJBool(prettyPrint))
  result = call_589147.call(path_589148, query_589149, nil, nil, nil)

var vaultMattersExportsGet* = Call_VaultMattersExportsGet_589130(
    name: "vaultMattersExportsGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/exports/{exportId}",
    validator: validate_VaultMattersExportsGet_589131, base: "/",
    url: url_VaultMattersExportsGet_589132, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsDelete_589150 = ref object of OpenApiRestCall_588450
proc url_VaultMattersExportsDelete_589152(protocol: Scheme; host: string;
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

proc validate_VaultMattersExportsDelete_589151(path: JsonNode; query: JsonNode;
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
  var valid_589153 = path.getOrDefault("exportId")
  valid_589153 = validateParameter(valid_589153, JString, required = true,
                                 default = nil)
  if valid_589153 != nil:
    section.add "exportId", valid_589153
  var valid_589154 = path.getOrDefault("matterId")
  valid_589154 = validateParameter(valid_589154, JString, required = true,
                                 default = nil)
  if valid_589154 != nil:
    section.add "matterId", valid_589154
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589155 = query.getOrDefault("upload_protocol")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "upload_protocol", valid_589155
  var valid_589156 = query.getOrDefault("fields")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "fields", valid_589156
  var valid_589157 = query.getOrDefault("quotaUser")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "quotaUser", valid_589157
  var valid_589158 = query.getOrDefault("alt")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = newJString("json"))
  if valid_589158 != nil:
    section.add "alt", valid_589158
  var valid_589159 = query.getOrDefault("oauth_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "oauth_token", valid_589159
  var valid_589160 = query.getOrDefault("callback")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "callback", valid_589160
  var valid_589161 = query.getOrDefault("access_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "access_token", valid_589161
  var valid_589162 = query.getOrDefault("uploadType")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "uploadType", valid_589162
  var valid_589163 = query.getOrDefault("key")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "key", valid_589163
  var valid_589164 = query.getOrDefault("$.xgafv")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = newJString("1"))
  if valid_589164 != nil:
    section.add "$.xgafv", valid_589164
  var valid_589165 = query.getOrDefault("prettyPrint")
  valid_589165 = validateParameter(valid_589165, JBool, required = false,
                                 default = newJBool(true))
  if valid_589165 != nil:
    section.add "prettyPrint", valid_589165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589166: Call_VaultMattersExportsDelete_589150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Export.
  ## 
  let valid = call_589166.validator(path, query, header, formData, body)
  let scheme = call_589166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589166.url(scheme.get, call_589166.host, call_589166.base,
                         call_589166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589166, url, valid)

proc call*(call_589167: Call_VaultMattersExportsDelete_589150; exportId: string;
          matterId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## vaultMattersExportsDelete
  ## Deletes an Export.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   exportId: string (required)
  ##           : The export ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589168 = newJObject()
  var query_589169 = newJObject()
  add(query_589169, "upload_protocol", newJString(uploadProtocol))
  add(query_589169, "fields", newJString(fields))
  add(query_589169, "quotaUser", newJString(quotaUser))
  add(query_589169, "alt", newJString(alt))
  add(path_589168, "exportId", newJString(exportId))
  add(query_589169, "oauth_token", newJString(oauthToken))
  add(query_589169, "callback", newJString(callback))
  add(query_589169, "access_token", newJString(accessToken))
  add(query_589169, "uploadType", newJString(uploadType))
  add(path_589168, "matterId", newJString(matterId))
  add(query_589169, "key", newJString(key))
  add(query_589169, "$.xgafv", newJString(Xgafv))
  add(query_589169, "prettyPrint", newJBool(prettyPrint))
  result = call_589167.call(path_589168, query_589169, nil, nil, nil)

var vaultMattersExportsDelete* = Call_VaultMattersExportsDelete_589150(
    name: "vaultMattersExportsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/exports/{exportId}",
    validator: validate_VaultMattersExportsDelete_589151, base: "/",
    url: url_VaultMattersExportsDelete_589152, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsCreate_589192 = ref object of OpenApiRestCall_588450
proc url_VaultMattersHoldsCreate_589194(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersHoldsCreate_589193(path: JsonNode; query: JsonNode;
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
  var valid_589195 = path.getOrDefault("matterId")
  valid_589195 = validateParameter(valid_589195, JString, required = true,
                                 default = nil)
  if valid_589195 != nil:
    section.add "matterId", valid_589195
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589196 = query.getOrDefault("upload_protocol")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "upload_protocol", valid_589196
  var valid_589197 = query.getOrDefault("fields")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "fields", valid_589197
  var valid_589198 = query.getOrDefault("quotaUser")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "quotaUser", valid_589198
  var valid_589199 = query.getOrDefault("alt")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = newJString("json"))
  if valid_589199 != nil:
    section.add "alt", valid_589199
  var valid_589200 = query.getOrDefault("oauth_token")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "oauth_token", valid_589200
  var valid_589201 = query.getOrDefault("callback")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "callback", valid_589201
  var valid_589202 = query.getOrDefault("access_token")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "access_token", valid_589202
  var valid_589203 = query.getOrDefault("uploadType")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "uploadType", valid_589203
  var valid_589204 = query.getOrDefault("key")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "key", valid_589204
  var valid_589205 = query.getOrDefault("$.xgafv")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("1"))
  if valid_589205 != nil:
    section.add "$.xgafv", valid_589205
  var valid_589206 = query.getOrDefault("prettyPrint")
  valid_589206 = validateParameter(valid_589206, JBool, required = false,
                                 default = newJBool(true))
  if valid_589206 != nil:
    section.add "prettyPrint", valid_589206
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

proc call*(call_589208: Call_VaultMattersHoldsCreate_589192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a hold in the given matter.
  ## 
  let valid = call_589208.validator(path, query, header, formData, body)
  let scheme = call_589208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589208.url(scheme.get, call_589208.host, call_589208.base,
                         call_589208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589208, url, valid)

proc call*(call_589209: Call_VaultMattersHoldsCreate_589192; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersHoldsCreate
  ## Creates a hold in the given matter.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589210 = newJObject()
  var query_589211 = newJObject()
  var body_589212 = newJObject()
  add(query_589211, "upload_protocol", newJString(uploadProtocol))
  add(query_589211, "fields", newJString(fields))
  add(query_589211, "quotaUser", newJString(quotaUser))
  add(query_589211, "alt", newJString(alt))
  add(query_589211, "oauth_token", newJString(oauthToken))
  add(query_589211, "callback", newJString(callback))
  add(query_589211, "access_token", newJString(accessToken))
  add(query_589211, "uploadType", newJString(uploadType))
  add(path_589210, "matterId", newJString(matterId))
  add(query_589211, "key", newJString(key))
  add(query_589211, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589212 = body
  add(query_589211, "prettyPrint", newJBool(prettyPrint))
  result = call_589209.call(path_589210, query_589211, nil, nil, body_589212)

var vaultMattersHoldsCreate* = Call_VaultMattersHoldsCreate_589192(
    name: "vaultMattersHoldsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds",
    validator: validate_VaultMattersHoldsCreate_589193, base: "/",
    url: url_VaultMattersHoldsCreate_589194, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsList_589170 = ref object of OpenApiRestCall_588450
proc url_VaultMattersHoldsList_589172(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersHoldsList_589171(path: JsonNode; query: JsonNode;
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
  var valid_589173 = path.getOrDefault("matterId")
  valid_589173 = validateParameter(valid_589173, JString, required = true,
                                 default = nil)
  if valid_589173 != nil:
    section.add "matterId", valid_589173
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pagination token as returned in the response.
  ## An empty token means start from the beginning.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Specifies which parts of the Hold to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The number of holds to return in the response, between 0 and 100 inclusive.
  ## Leaving this empty, or as 0, is the same as page_size = 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589174 = query.getOrDefault("upload_protocol")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "upload_protocol", valid_589174
  var valid_589175 = query.getOrDefault("fields")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "fields", valid_589175
  var valid_589176 = query.getOrDefault("pageToken")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "pageToken", valid_589176
  var valid_589177 = query.getOrDefault("quotaUser")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "quotaUser", valid_589177
  var valid_589178 = query.getOrDefault("view")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = newJString("HOLD_VIEW_UNSPECIFIED"))
  if valid_589178 != nil:
    section.add "view", valid_589178
  var valid_589179 = query.getOrDefault("alt")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = newJString("json"))
  if valid_589179 != nil:
    section.add "alt", valid_589179
  var valid_589180 = query.getOrDefault("oauth_token")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "oauth_token", valid_589180
  var valid_589181 = query.getOrDefault("callback")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "callback", valid_589181
  var valid_589182 = query.getOrDefault("access_token")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "access_token", valid_589182
  var valid_589183 = query.getOrDefault("uploadType")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "uploadType", valid_589183
  var valid_589184 = query.getOrDefault("key")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "key", valid_589184
  var valid_589185 = query.getOrDefault("$.xgafv")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = newJString("1"))
  if valid_589185 != nil:
    section.add "$.xgafv", valid_589185
  var valid_589186 = query.getOrDefault("pageSize")
  valid_589186 = validateParameter(valid_589186, JInt, required = false, default = nil)
  if valid_589186 != nil:
    section.add "pageSize", valid_589186
  var valid_589187 = query.getOrDefault("prettyPrint")
  valid_589187 = validateParameter(valid_589187, JBool, required = false,
                                 default = newJBool(true))
  if valid_589187 != nil:
    section.add "prettyPrint", valid_589187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589188: Call_VaultMattersHoldsList_589170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists holds within a matter. An empty page token in ListHoldsResponse
  ## denotes no more holds to list.
  ## 
  let valid = call_589188.validator(path, query, header, formData, body)
  let scheme = call_589188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589188.url(scheme.get, call_589188.host, call_589188.base,
                         call_589188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589188, url, valid)

proc call*(call_589189: Call_VaultMattersHoldsList_589170; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "HOLD_VIEW_UNSPECIFIED";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## vaultMattersHoldsList
  ## Lists holds within a matter. An empty page token in ListHoldsResponse
  ## denotes no more holds to list.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pagination token as returned in the response.
  ## An empty token means start from the beginning.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Specifies which parts of the Hold to return.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of holds to return in the response, between 0 and 100 inclusive.
  ## Leaving this empty, or as 0, is the same as page_size = 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589190 = newJObject()
  var query_589191 = newJObject()
  add(query_589191, "upload_protocol", newJString(uploadProtocol))
  add(query_589191, "fields", newJString(fields))
  add(query_589191, "pageToken", newJString(pageToken))
  add(query_589191, "quotaUser", newJString(quotaUser))
  add(query_589191, "view", newJString(view))
  add(query_589191, "alt", newJString(alt))
  add(query_589191, "oauth_token", newJString(oauthToken))
  add(query_589191, "callback", newJString(callback))
  add(query_589191, "access_token", newJString(accessToken))
  add(query_589191, "uploadType", newJString(uploadType))
  add(path_589190, "matterId", newJString(matterId))
  add(query_589191, "key", newJString(key))
  add(query_589191, "$.xgafv", newJString(Xgafv))
  add(query_589191, "pageSize", newJInt(pageSize))
  add(query_589191, "prettyPrint", newJBool(prettyPrint))
  result = call_589189.call(path_589190, query_589191, nil, nil, nil)

var vaultMattersHoldsList* = Call_VaultMattersHoldsList_589170(
    name: "vaultMattersHoldsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds",
    validator: validate_VaultMattersHoldsList_589171, base: "/",
    url: url_VaultMattersHoldsList_589172, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsUpdate_589234 = ref object of OpenApiRestCall_588450
proc url_VaultMattersHoldsUpdate_589236(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersHoldsUpdate_589235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the OU and/or query parameters of a hold. You cannot add accounts
  ## to a hold that covers an OU, nor can you add OUs to a hold that covers
  ## individual accounts. Accounts listed in the hold will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  ##   holdId: JString (required)
  ##         : The ID of the hold.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_589237 = path.getOrDefault("matterId")
  valid_589237 = validateParameter(valid_589237, JString, required = true,
                                 default = nil)
  if valid_589237 != nil:
    section.add "matterId", valid_589237
  var valid_589238 = path.getOrDefault("holdId")
  valid_589238 = validateParameter(valid_589238, JString, required = true,
                                 default = nil)
  if valid_589238 != nil:
    section.add "holdId", valid_589238
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589239 = query.getOrDefault("upload_protocol")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "upload_protocol", valid_589239
  var valid_589240 = query.getOrDefault("fields")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "fields", valid_589240
  var valid_589241 = query.getOrDefault("quotaUser")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "quotaUser", valid_589241
  var valid_589242 = query.getOrDefault("alt")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = newJString("json"))
  if valid_589242 != nil:
    section.add "alt", valid_589242
  var valid_589243 = query.getOrDefault("oauth_token")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "oauth_token", valid_589243
  var valid_589244 = query.getOrDefault("callback")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "callback", valid_589244
  var valid_589245 = query.getOrDefault("access_token")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "access_token", valid_589245
  var valid_589246 = query.getOrDefault("uploadType")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "uploadType", valid_589246
  var valid_589247 = query.getOrDefault("key")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "key", valid_589247
  var valid_589248 = query.getOrDefault("$.xgafv")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = newJString("1"))
  if valid_589248 != nil:
    section.add "$.xgafv", valid_589248
  var valid_589249 = query.getOrDefault("prettyPrint")
  valid_589249 = validateParameter(valid_589249, JBool, required = false,
                                 default = newJBool(true))
  if valid_589249 != nil:
    section.add "prettyPrint", valid_589249
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

proc call*(call_589251: Call_VaultMattersHoldsUpdate_589234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the OU and/or query parameters of a hold. You cannot add accounts
  ## to a hold that covers an OU, nor can you add OUs to a hold that covers
  ## individual accounts. Accounts listed in the hold will be ignored.
  ## 
  let valid = call_589251.validator(path, query, header, formData, body)
  let scheme = call_589251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589251.url(scheme.get, call_589251.host, call_589251.base,
                         call_589251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589251, url, valid)

proc call*(call_589252: Call_VaultMattersHoldsUpdate_589234; matterId: string;
          holdId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## vaultMattersHoldsUpdate
  ## Updates the OU and/or query parameters of a hold. You cannot add accounts
  ## to a hold that covers an OU, nor can you add OUs to a hold that covers
  ## individual accounts. Accounts listed in the hold will be ignored.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   holdId: string (required)
  ##         : The ID of the hold.
  var path_589253 = newJObject()
  var query_589254 = newJObject()
  var body_589255 = newJObject()
  add(query_589254, "upload_protocol", newJString(uploadProtocol))
  add(query_589254, "fields", newJString(fields))
  add(query_589254, "quotaUser", newJString(quotaUser))
  add(query_589254, "alt", newJString(alt))
  add(query_589254, "oauth_token", newJString(oauthToken))
  add(query_589254, "callback", newJString(callback))
  add(query_589254, "access_token", newJString(accessToken))
  add(query_589254, "uploadType", newJString(uploadType))
  add(path_589253, "matterId", newJString(matterId))
  add(query_589254, "key", newJString(key))
  add(query_589254, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589255 = body
  add(query_589254, "prettyPrint", newJBool(prettyPrint))
  add(path_589253, "holdId", newJString(holdId))
  result = call_589252.call(path_589253, query_589254, nil, nil, body_589255)

var vaultMattersHoldsUpdate* = Call_VaultMattersHoldsUpdate_589234(
    name: "vaultMattersHoldsUpdate", meth: HttpMethod.HttpPut,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsUpdate_589235, base: "/",
    url: url_VaultMattersHoldsUpdate_589236, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsGet_589213 = ref object of OpenApiRestCall_588450
proc url_VaultMattersHoldsGet_589215(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersHoldsGet_589214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a hold by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  ##   holdId: JString (required)
  ##         : The hold ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_589216 = path.getOrDefault("matterId")
  valid_589216 = validateParameter(valid_589216, JString, required = true,
                                 default = nil)
  if valid_589216 != nil:
    section.add "matterId", valid_589216
  var valid_589217 = path.getOrDefault("holdId")
  valid_589217 = validateParameter(valid_589217, JString, required = true,
                                 default = nil)
  if valid_589217 != nil:
    section.add "holdId", valid_589217
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Specifies which parts of the Hold to return.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589218 = query.getOrDefault("upload_protocol")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "upload_protocol", valid_589218
  var valid_589219 = query.getOrDefault("fields")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "fields", valid_589219
  var valid_589220 = query.getOrDefault("view")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = newJString("HOLD_VIEW_UNSPECIFIED"))
  if valid_589220 != nil:
    section.add "view", valid_589220
  var valid_589221 = query.getOrDefault("quotaUser")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "quotaUser", valid_589221
  var valid_589222 = query.getOrDefault("alt")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = newJString("json"))
  if valid_589222 != nil:
    section.add "alt", valid_589222
  var valid_589223 = query.getOrDefault("oauth_token")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "oauth_token", valid_589223
  var valid_589224 = query.getOrDefault("callback")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "callback", valid_589224
  var valid_589225 = query.getOrDefault("access_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "access_token", valid_589225
  var valid_589226 = query.getOrDefault("uploadType")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "uploadType", valid_589226
  var valid_589227 = query.getOrDefault("key")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "key", valid_589227
  var valid_589228 = query.getOrDefault("$.xgafv")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("1"))
  if valid_589228 != nil:
    section.add "$.xgafv", valid_589228
  var valid_589229 = query.getOrDefault("prettyPrint")
  valid_589229 = validateParameter(valid_589229, JBool, required = false,
                                 default = newJBool(true))
  if valid_589229 != nil:
    section.add "prettyPrint", valid_589229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589230: Call_VaultMattersHoldsGet_589213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a hold by ID.
  ## 
  let valid = call_589230.validator(path, query, header, formData, body)
  let scheme = call_589230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589230.url(scheme.get, call_589230.host, call_589230.base,
                         call_589230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589230, url, valid)

proc call*(call_589231: Call_VaultMattersHoldsGet_589213; matterId: string;
          holdId: string; uploadProtocol: string = ""; fields: string = "";
          view: string = "HOLD_VIEW_UNSPECIFIED"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## vaultMattersHoldsGet
  ## Gets a hold by ID.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Specifies which parts of the Hold to return.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   holdId: string (required)
  ##         : The hold ID.
  var path_589232 = newJObject()
  var query_589233 = newJObject()
  add(query_589233, "upload_protocol", newJString(uploadProtocol))
  add(query_589233, "fields", newJString(fields))
  add(query_589233, "view", newJString(view))
  add(query_589233, "quotaUser", newJString(quotaUser))
  add(query_589233, "alt", newJString(alt))
  add(query_589233, "oauth_token", newJString(oauthToken))
  add(query_589233, "callback", newJString(callback))
  add(query_589233, "access_token", newJString(accessToken))
  add(query_589233, "uploadType", newJString(uploadType))
  add(path_589232, "matterId", newJString(matterId))
  add(query_589233, "key", newJString(key))
  add(query_589233, "$.xgafv", newJString(Xgafv))
  add(query_589233, "prettyPrint", newJBool(prettyPrint))
  add(path_589232, "holdId", newJString(holdId))
  result = call_589231.call(path_589232, query_589233, nil, nil, nil)

var vaultMattersHoldsGet* = Call_VaultMattersHoldsGet_589213(
    name: "vaultMattersHoldsGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsGet_589214, base: "/",
    url: url_VaultMattersHoldsGet_589215, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsDelete_589256 = ref object of OpenApiRestCall_588450
proc url_VaultMattersHoldsDelete_589258(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersHoldsDelete_589257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a hold by ID. This will release any HeldAccounts on this Hold.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  ##   holdId: JString (required)
  ##         : The hold ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_589259 = path.getOrDefault("matterId")
  valid_589259 = validateParameter(valid_589259, JString, required = true,
                                 default = nil)
  if valid_589259 != nil:
    section.add "matterId", valid_589259
  var valid_589260 = path.getOrDefault("holdId")
  valid_589260 = validateParameter(valid_589260, JString, required = true,
                                 default = nil)
  if valid_589260 != nil:
    section.add "holdId", valid_589260
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589261 = query.getOrDefault("upload_protocol")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "upload_protocol", valid_589261
  var valid_589262 = query.getOrDefault("fields")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "fields", valid_589262
  var valid_589263 = query.getOrDefault("quotaUser")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "quotaUser", valid_589263
  var valid_589264 = query.getOrDefault("alt")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = newJString("json"))
  if valid_589264 != nil:
    section.add "alt", valid_589264
  var valid_589265 = query.getOrDefault("oauth_token")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "oauth_token", valid_589265
  var valid_589266 = query.getOrDefault("callback")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "callback", valid_589266
  var valid_589267 = query.getOrDefault("access_token")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "access_token", valid_589267
  var valid_589268 = query.getOrDefault("uploadType")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "uploadType", valid_589268
  var valid_589269 = query.getOrDefault("key")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "key", valid_589269
  var valid_589270 = query.getOrDefault("$.xgafv")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = newJString("1"))
  if valid_589270 != nil:
    section.add "$.xgafv", valid_589270
  var valid_589271 = query.getOrDefault("prettyPrint")
  valid_589271 = validateParameter(valid_589271, JBool, required = false,
                                 default = newJBool(true))
  if valid_589271 != nil:
    section.add "prettyPrint", valid_589271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589272: Call_VaultMattersHoldsDelete_589256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a hold by ID. This will release any HeldAccounts on this Hold.
  ## 
  let valid = call_589272.validator(path, query, header, formData, body)
  let scheme = call_589272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589272.url(scheme.get, call_589272.host, call_589272.base,
                         call_589272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589272, url, valid)

proc call*(call_589273: Call_VaultMattersHoldsDelete_589256; matterId: string;
          holdId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## vaultMattersHoldsDelete
  ## Removes a hold by ID. This will release any HeldAccounts on this Hold.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   holdId: string (required)
  ##         : The hold ID.
  var path_589274 = newJObject()
  var query_589275 = newJObject()
  add(query_589275, "upload_protocol", newJString(uploadProtocol))
  add(query_589275, "fields", newJString(fields))
  add(query_589275, "quotaUser", newJString(quotaUser))
  add(query_589275, "alt", newJString(alt))
  add(query_589275, "oauth_token", newJString(oauthToken))
  add(query_589275, "callback", newJString(callback))
  add(query_589275, "access_token", newJString(accessToken))
  add(query_589275, "uploadType", newJString(uploadType))
  add(path_589274, "matterId", newJString(matterId))
  add(query_589275, "key", newJString(key))
  add(query_589275, "$.xgafv", newJString(Xgafv))
  add(query_589275, "prettyPrint", newJBool(prettyPrint))
  add(path_589274, "holdId", newJString(holdId))
  result = call_589273.call(path_589274, query_589275, nil, nil, nil)

var vaultMattersHoldsDelete* = Call_VaultMattersHoldsDelete_589256(
    name: "vaultMattersHoldsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsDelete_589257, base: "/",
    url: url_VaultMattersHoldsDelete_589258, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsCreate_589296 = ref object of OpenApiRestCall_588450
proc url_VaultMattersHoldsAccountsCreate_589298(protocol: Scheme; host: string;
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

proc validate_VaultMattersHoldsAccountsCreate_589297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a HeldAccount to a hold. Accounts can only be added to a hold that
  ## has no held_org_unit set. Attempting to add an account to an OU-based
  ## hold will result in an error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  ##   holdId: JString (required)
  ##         : The hold ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_589299 = path.getOrDefault("matterId")
  valid_589299 = validateParameter(valid_589299, JString, required = true,
                                 default = nil)
  if valid_589299 != nil:
    section.add "matterId", valid_589299
  var valid_589300 = path.getOrDefault("holdId")
  valid_589300 = validateParameter(valid_589300, JString, required = true,
                                 default = nil)
  if valid_589300 != nil:
    section.add "holdId", valid_589300
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589301 = query.getOrDefault("upload_protocol")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "upload_protocol", valid_589301
  var valid_589302 = query.getOrDefault("fields")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "fields", valid_589302
  var valid_589303 = query.getOrDefault("quotaUser")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "quotaUser", valid_589303
  var valid_589304 = query.getOrDefault("alt")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("json"))
  if valid_589304 != nil:
    section.add "alt", valid_589304
  var valid_589305 = query.getOrDefault("oauth_token")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "oauth_token", valid_589305
  var valid_589306 = query.getOrDefault("callback")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "callback", valid_589306
  var valid_589307 = query.getOrDefault("access_token")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "access_token", valid_589307
  var valid_589308 = query.getOrDefault("uploadType")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "uploadType", valid_589308
  var valid_589309 = query.getOrDefault("key")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "key", valid_589309
  var valid_589310 = query.getOrDefault("$.xgafv")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = newJString("1"))
  if valid_589310 != nil:
    section.add "$.xgafv", valid_589310
  var valid_589311 = query.getOrDefault("prettyPrint")
  valid_589311 = validateParameter(valid_589311, JBool, required = false,
                                 default = newJBool(true))
  if valid_589311 != nil:
    section.add "prettyPrint", valid_589311
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

proc call*(call_589313: Call_VaultMattersHoldsAccountsCreate_589296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a HeldAccount to a hold. Accounts can only be added to a hold that
  ## has no held_org_unit set. Attempting to add an account to an OU-based
  ## hold will result in an error.
  ## 
  let valid = call_589313.validator(path, query, header, formData, body)
  let scheme = call_589313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589313.url(scheme.get, call_589313.host, call_589313.base,
                         call_589313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589313, url, valid)

proc call*(call_589314: Call_VaultMattersHoldsAccountsCreate_589296;
          matterId: string; holdId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersHoldsAccountsCreate
  ## Adds a HeldAccount to a hold. Accounts can only be added to a hold that
  ## has no held_org_unit set. Attempting to add an account to an OU-based
  ## hold will result in an error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   holdId: string (required)
  ##         : The hold ID.
  var path_589315 = newJObject()
  var query_589316 = newJObject()
  var body_589317 = newJObject()
  add(query_589316, "upload_protocol", newJString(uploadProtocol))
  add(query_589316, "fields", newJString(fields))
  add(query_589316, "quotaUser", newJString(quotaUser))
  add(query_589316, "alt", newJString(alt))
  add(query_589316, "oauth_token", newJString(oauthToken))
  add(query_589316, "callback", newJString(callback))
  add(query_589316, "access_token", newJString(accessToken))
  add(query_589316, "uploadType", newJString(uploadType))
  add(path_589315, "matterId", newJString(matterId))
  add(query_589316, "key", newJString(key))
  add(query_589316, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589317 = body
  add(query_589316, "prettyPrint", newJBool(prettyPrint))
  add(path_589315, "holdId", newJString(holdId))
  result = call_589314.call(path_589315, query_589316, nil, nil, body_589317)

var vaultMattersHoldsAccountsCreate* = Call_VaultMattersHoldsAccountsCreate_589296(
    name: "vaultMattersHoldsAccountsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts",
    validator: validate_VaultMattersHoldsAccountsCreate_589297, base: "/",
    url: url_VaultMattersHoldsAccountsCreate_589298, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsList_589276 = ref object of OpenApiRestCall_588450
proc url_VaultMattersHoldsAccountsList_589278(protocol: Scheme; host: string;
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

proc validate_VaultMattersHoldsAccountsList_589277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists HeldAccounts for a hold. This will only list individually specified
  ## held accounts. If the hold is on an OU, then use
  ## <a href="https://developers.google.com/admin-sdk/">Admin SDK</a>
  ## to enumerate its members.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  ##   holdId: JString (required)
  ##         : The hold ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_589279 = path.getOrDefault("matterId")
  valid_589279 = validateParameter(valid_589279, JString, required = true,
                                 default = nil)
  if valid_589279 != nil:
    section.add "matterId", valid_589279
  var valid_589280 = path.getOrDefault("holdId")
  valid_589280 = validateParameter(valid_589280, JString, required = true,
                                 default = nil)
  if valid_589280 != nil:
    section.add "holdId", valid_589280
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589281 = query.getOrDefault("upload_protocol")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "upload_protocol", valid_589281
  var valid_589282 = query.getOrDefault("fields")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "fields", valid_589282
  var valid_589283 = query.getOrDefault("quotaUser")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "quotaUser", valid_589283
  var valid_589284 = query.getOrDefault("alt")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = newJString("json"))
  if valid_589284 != nil:
    section.add "alt", valid_589284
  var valid_589285 = query.getOrDefault("oauth_token")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "oauth_token", valid_589285
  var valid_589286 = query.getOrDefault("callback")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "callback", valid_589286
  var valid_589287 = query.getOrDefault("access_token")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "access_token", valid_589287
  var valid_589288 = query.getOrDefault("uploadType")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "uploadType", valid_589288
  var valid_589289 = query.getOrDefault("key")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "key", valid_589289
  var valid_589290 = query.getOrDefault("$.xgafv")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = newJString("1"))
  if valid_589290 != nil:
    section.add "$.xgafv", valid_589290
  var valid_589291 = query.getOrDefault("prettyPrint")
  valid_589291 = validateParameter(valid_589291, JBool, required = false,
                                 default = newJBool(true))
  if valid_589291 != nil:
    section.add "prettyPrint", valid_589291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589292: Call_VaultMattersHoldsAccountsList_589276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists HeldAccounts for a hold. This will only list individually specified
  ## held accounts. If the hold is on an OU, then use
  ## <a href="https://developers.google.com/admin-sdk/">Admin SDK</a>
  ## to enumerate its members.
  ## 
  let valid = call_589292.validator(path, query, header, formData, body)
  let scheme = call_589292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589292.url(scheme.get, call_589292.host, call_589292.base,
                         call_589292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589292, url, valid)

proc call*(call_589293: Call_VaultMattersHoldsAccountsList_589276;
          matterId: string; holdId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## vaultMattersHoldsAccountsList
  ## Lists HeldAccounts for a hold. This will only list individually specified
  ## held accounts. If the hold is on an OU, then use
  ## <a href="https://developers.google.com/admin-sdk/">Admin SDK</a>
  ## to enumerate its members.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   holdId: string (required)
  ##         : The hold ID.
  var path_589294 = newJObject()
  var query_589295 = newJObject()
  add(query_589295, "upload_protocol", newJString(uploadProtocol))
  add(query_589295, "fields", newJString(fields))
  add(query_589295, "quotaUser", newJString(quotaUser))
  add(query_589295, "alt", newJString(alt))
  add(query_589295, "oauth_token", newJString(oauthToken))
  add(query_589295, "callback", newJString(callback))
  add(query_589295, "access_token", newJString(accessToken))
  add(query_589295, "uploadType", newJString(uploadType))
  add(path_589294, "matterId", newJString(matterId))
  add(query_589295, "key", newJString(key))
  add(query_589295, "$.xgafv", newJString(Xgafv))
  add(query_589295, "prettyPrint", newJBool(prettyPrint))
  add(path_589294, "holdId", newJString(holdId))
  result = call_589293.call(path_589294, query_589295, nil, nil, nil)

var vaultMattersHoldsAccountsList* = Call_VaultMattersHoldsAccountsList_589276(
    name: "vaultMattersHoldsAccountsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts",
    validator: validate_VaultMattersHoldsAccountsList_589277, base: "/",
    url: url_VaultMattersHoldsAccountsList_589278, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsDelete_589318 = ref object of OpenApiRestCall_588450
proc url_VaultMattersHoldsAccountsDelete_589320(protocol: Scheme; host: string;
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

proc validate_VaultMattersHoldsAccountsDelete_589319(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a HeldAccount from a hold. If this request leaves the hold with
  ## no held accounts, the hold will not apply to any accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The ID of the account to remove from the hold.
  ##   matterId: JString (required)
  ##           : The matter ID.
  ##   holdId: JString (required)
  ##         : The hold ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589321 = path.getOrDefault("accountId")
  valid_589321 = validateParameter(valid_589321, JString, required = true,
                                 default = nil)
  if valid_589321 != nil:
    section.add "accountId", valid_589321
  var valid_589322 = path.getOrDefault("matterId")
  valid_589322 = validateParameter(valid_589322, JString, required = true,
                                 default = nil)
  if valid_589322 != nil:
    section.add "matterId", valid_589322
  var valid_589323 = path.getOrDefault("holdId")
  valid_589323 = validateParameter(valid_589323, JString, required = true,
                                 default = nil)
  if valid_589323 != nil:
    section.add "holdId", valid_589323
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589324 = query.getOrDefault("upload_protocol")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "upload_protocol", valid_589324
  var valid_589325 = query.getOrDefault("fields")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "fields", valid_589325
  var valid_589326 = query.getOrDefault("quotaUser")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "quotaUser", valid_589326
  var valid_589327 = query.getOrDefault("alt")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = newJString("json"))
  if valid_589327 != nil:
    section.add "alt", valid_589327
  var valid_589328 = query.getOrDefault("oauth_token")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "oauth_token", valid_589328
  var valid_589329 = query.getOrDefault("callback")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "callback", valid_589329
  var valid_589330 = query.getOrDefault("access_token")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "access_token", valid_589330
  var valid_589331 = query.getOrDefault("uploadType")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "uploadType", valid_589331
  var valid_589332 = query.getOrDefault("key")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "key", valid_589332
  var valid_589333 = query.getOrDefault("$.xgafv")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = newJString("1"))
  if valid_589333 != nil:
    section.add "$.xgafv", valid_589333
  var valid_589334 = query.getOrDefault("prettyPrint")
  valid_589334 = validateParameter(valid_589334, JBool, required = false,
                                 default = newJBool(true))
  if valid_589334 != nil:
    section.add "prettyPrint", valid_589334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589335: Call_VaultMattersHoldsAccountsDelete_589318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a HeldAccount from a hold. If this request leaves the hold with
  ## no held accounts, the hold will not apply to any accounts.
  ## 
  let valid = call_589335.validator(path, query, header, formData, body)
  let scheme = call_589335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589335.url(scheme.get, call_589335.host, call_589335.base,
                         call_589335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589335, url, valid)

proc call*(call_589336: Call_VaultMattersHoldsAccountsDelete_589318;
          accountId: string; matterId: string; holdId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## vaultMattersHoldsAccountsDelete
  ## Removes a HeldAccount from a hold. If this request leaves the hold with
  ## no held accounts, the hold will not apply to any accounts.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accountId: string (required)
  ##            : The ID of the account to remove from the hold.
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   holdId: string (required)
  ##         : The hold ID.
  var path_589337 = newJObject()
  var query_589338 = newJObject()
  add(query_589338, "upload_protocol", newJString(uploadProtocol))
  add(query_589338, "fields", newJString(fields))
  add(query_589338, "quotaUser", newJString(quotaUser))
  add(query_589338, "alt", newJString(alt))
  add(query_589338, "oauth_token", newJString(oauthToken))
  add(query_589338, "callback", newJString(callback))
  add(query_589338, "access_token", newJString(accessToken))
  add(query_589338, "uploadType", newJString(uploadType))
  add(path_589337, "accountId", newJString(accountId))
  add(path_589337, "matterId", newJString(matterId))
  add(query_589338, "key", newJString(key))
  add(query_589338, "$.xgafv", newJString(Xgafv))
  add(query_589338, "prettyPrint", newJBool(prettyPrint))
  add(path_589337, "holdId", newJString(holdId))
  result = call_589336.call(path_589337, query_589338, nil, nil, nil)

var vaultMattersHoldsAccountsDelete* = Call_VaultMattersHoldsAccountsDelete_589318(
    name: "vaultMattersHoldsAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts/{accountId}",
    validator: validate_VaultMattersHoldsAccountsDelete_589319, base: "/",
    url: url_VaultMattersHoldsAccountsDelete_589320, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAddHeldAccounts_589339 = ref object of OpenApiRestCall_588450
proc url_VaultMattersHoldsAddHeldAccounts_589341(protocol: Scheme; host: string;
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

proc validate_VaultMattersHoldsAddHeldAccounts_589340(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds HeldAccounts to a hold. Returns a list of accounts that have been
  ## successfully added. Accounts can only be added to an existing account-based
  ## hold.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  ##   holdId: JString (required)
  ##         : The hold ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_589342 = path.getOrDefault("matterId")
  valid_589342 = validateParameter(valid_589342, JString, required = true,
                                 default = nil)
  if valid_589342 != nil:
    section.add "matterId", valid_589342
  var valid_589343 = path.getOrDefault("holdId")
  valid_589343 = validateParameter(valid_589343, JString, required = true,
                                 default = nil)
  if valid_589343 != nil:
    section.add "holdId", valid_589343
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589344 = query.getOrDefault("upload_protocol")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "upload_protocol", valid_589344
  var valid_589345 = query.getOrDefault("fields")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "fields", valid_589345
  var valid_589346 = query.getOrDefault("quotaUser")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "quotaUser", valid_589346
  var valid_589347 = query.getOrDefault("alt")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = newJString("json"))
  if valid_589347 != nil:
    section.add "alt", valid_589347
  var valid_589348 = query.getOrDefault("oauth_token")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "oauth_token", valid_589348
  var valid_589349 = query.getOrDefault("callback")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "callback", valid_589349
  var valid_589350 = query.getOrDefault("access_token")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "access_token", valid_589350
  var valid_589351 = query.getOrDefault("uploadType")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "uploadType", valid_589351
  var valid_589352 = query.getOrDefault("key")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "key", valid_589352
  var valid_589353 = query.getOrDefault("$.xgafv")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = newJString("1"))
  if valid_589353 != nil:
    section.add "$.xgafv", valid_589353
  var valid_589354 = query.getOrDefault("prettyPrint")
  valid_589354 = validateParameter(valid_589354, JBool, required = false,
                                 default = newJBool(true))
  if valid_589354 != nil:
    section.add "prettyPrint", valid_589354
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

proc call*(call_589356: Call_VaultMattersHoldsAddHeldAccounts_589339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds HeldAccounts to a hold. Returns a list of accounts that have been
  ## successfully added. Accounts can only be added to an existing account-based
  ## hold.
  ## 
  let valid = call_589356.validator(path, query, header, formData, body)
  let scheme = call_589356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589356.url(scheme.get, call_589356.host, call_589356.base,
                         call_589356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589356, url, valid)

proc call*(call_589357: Call_VaultMattersHoldsAddHeldAccounts_589339;
          matterId: string; holdId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersHoldsAddHeldAccounts
  ## Adds HeldAccounts to a hold. Returns a list of accounts that have been
  ## successfully added. Accounts can only be added to an existing account-based
  ## hold.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   holdId: string (required)
  ##         : The hold ID.
  var path_589358 = newJObject()
  var query_589359 = newJObject()
  var body_589360 = newJObject()
  add(query_589359, "upload_protocol", newJString(uploadProtocol))
  add(query_589359, "fields", newJString(fields))
  add(query_589359, "quotaUser", newJString(quotaUser))
  add(query_589359, "alt", newJString(alt))
  add(query_589359, "oauth_token", newJString(oauthToken))
  add(query_589359, "callback", newJString(callback))
  add(query_589359, "access_token", newJString(accessToken))
  add(query_589359, "uploadType", newJString(uploadType))
  add(path_589358, "matterId", newJString(matterId))
  add(query_589359, "key", newJString(key))
  add(query_589359, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589360 = body
  add(query_589359, "prettyPrint", newJBool(prettyPrint))
  add(path_589358, "holdId", newJString(holdId))
  result = call_589357.call(path_589358, query_589359, nil, nil, body_589360)

var vaultMattersHoldsAddHeldAccounts* = Call_VaultMattersHoldsAddHeldAccounts_589339(
    name: "vaultMattersHoldsAddHeldAccounts", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}:addHeldAccounts",
    validator: validate_VaultMattersHoldsAddHeldAccounts_589340, base: "/",
    url: url_VaultMattersHoldsAddHeldAccounts_589341, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsRemoveHeldAccounts_589361 = ref object of OpenApiRestCall_588450
proc url_VaultMattersHoldsRemoveHeldAccounts_589363(protocol: Scheme; host: string;
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

proc validate_VaultMattersHoldsRemoveHeldAccounts_589362(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes HeldAccounts from a hold. Returns a list of statuses in the same
  ## order as the request. If this request leaves the hold with no held
  ## accounts, the hold will not apply to any accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter ID.
  ##   holdId: JString (required)
  ##         : The hold ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_589364 = path.getOrDefault("matterId")
  valid_589364 = validateParameter(valid_589364, JString, required = true,
                                 default = nil)
  if valid_589364 != nil:
    section.add "matterId", valid_589364
  var valid_589365 = path.getOrDefault("holdId")
  valid_589365 = validateParameter(valid_589365, JString, required = true,
                                 default = nil)
  if valid_589365 != nil:
    section.add "holdId", valid_589365
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589366 = query.getOrDefault("upload_protocol")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "upload_protocol", valid_589366
  var valid_589367 = query.getOrDefault("fields")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "fields", valid_589367
  var valid_589368 = query.getOrDefault("quotaUser")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "quotaUser", valid_589368
  var valid_589369 = query.getOrDefault("alt")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = newJString("json"))
  if valid_589369 != nil:
    section.add "alt", valid_589369
  var valid_589370 = query.getOrDefault("oauth_token")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "oauth_token", valid_589370
  var valid_589371 = query.getOrDefault("callback")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "callback", valid_589371
  var valid_589372 = query.getOrDefault("access_token")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "access_token", valid_589372
  var valid_589373 = query.getOrDefault("uploadType")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "uploadType", valid_589373
  var valid_589374 = query.getOrDefault("key")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "key", valid_589374
  var valid_589375 = query.getOrDefault("$.xgafv")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = newJString("1"))
  if valid_589375 != nil:
    section.add "$.xgafv", valid_589375
  var valid_589376 = query.getOrDefault("prettyPrint")
  valid_589376 = validateParameter(valid_589376, JBool, required = false,
                                 default = newJBool(true))
  if valid_589376 != nil:
    section.add "prettyPrint", valid_589376
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

proc call*(call_589378: Call_VaultMattersHoldsRemoveHeldAccounts_589361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes HeldAccounts from a hold. Returns a list of statuses in the same
  ## order as the request. If this request leaves the hold with no held
  ## accounts, the hold will not apply to any accounts.
  ## 
  let valid = call_589378.validator(path, query, header, formData, body)
  let scheme = call_589378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589378.url(scheme.get, call_589378.host, call_589378.base,
                         call_589378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589378, url, valid)

proc call*(call_589379: Call_VaultMattersHoldsRemoveHeldAccounts_589361;
          matterId: string; holdId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersHoldsRemoveHeldAccounts
  ## Removes HeldAccounts from a hold. Returns a list of statuses in the same
  ## order as the request. If this request leaves the hold with no held
  ## accounts, the hold will not apply to any accounts.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   holdId: string (required)
  ##         : The hold ID.
  var path_589380 = newJObject()
  var query_589381 = newJObject()
  var body_589382 = newJObject()
  add(query_589381, "upload_protocol", newJString(uploadProtocol))
  add(query_589381, "fields", newJString(fields))
  add(query_589381, "quotaUser", newJString(quotaUser))
  add(query_589381, "alt", newJString(alt))
  add(query_589381, "oauth_token", newJString(oauthToken))
  add(query_589381, "callback", newJString(callback))
  add(query_589381, "access_token", newJString(accessToken))
  add(query_589381, "uploadType", newJString(uploadType))
  add(path_589380, "matterId", newJString(matterId))
  add(query_589381, "key", newJString(key))
  add(query_589381, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589382 = body
  add(query_589381, "prettyPrint", newJBool(prettyPrint))
  add(path_589380, "holdId", newJString(holdId))
  result = call_589379.call(path_589380, query_589381, nil, nil, body_589382)

var vaultMattersHoldsRemoveHeldAccounts* = Call_VaultMattersHoldsRemoveHeldAccounts_589361(
    name: "vaultMattersHoldsRemoveHeldAccounts", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}:removeHeldAccounts",
    validator: validate_VaultMattersHoldsRemoveHeldAccounts_589362, base: "/",
    url: url_VaultMattersHoldsRemoveHeldAccounts_589363, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesCreate_589404 = ref object of OpenApiRestCall_588450
proc url_VaultMattersSavedQueriesCreate_589406(protocol: Scheme; host: string;
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

proc validate_VaultMattersSavedQueriesCreate_589405(path: JsonNode;
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
  var valid_589407 = path.getOrDefault("matterId")
  valid_589407 = validateParameter(valid_589407, JString, required = true,
                                 default = nil)
  if valid_589407 != nil:
    section.add "matterId", valid_589407
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589408 = query.getOrDefault("upload_protocol")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "upload_protocol", valid_589408
  var valid_589409 = query.getOrDefault("fields")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "fields", valid_589409
  var valid_589410 = query.getOrDefault("quotaUser")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "quotaUser", valid_589410
  var valid_589411 = query.getOrDefault("alt")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = newJString("json"))
  if valid_589411 != nil:
    section.add "alt", valid_589411
  var valid_589412 = query.getOrDefault("oauth_token")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "oauth_token", valid_589412
  var valid_589413 = query.getOrDefault("callback")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "callback", valid_589413
  var valid_589414 = query.getOrDefault("access_token")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "access_token", valid_589414
  var valid_589415 = query.getOrDefault("uploadType")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "uploadType", valid_589415
  var valid_589416 = query.getOrDefault("key")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "key", valid_589416
  var valid_589417 = query.getOrDefault("$.xgafv")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = newJString("1"))
  if valid_589417 != nil:
    section.add "$.xgafv", valid_589417
  var valid_589418 = query.getOrDefault("prettyPrint")
  valid_589418 = validateParameter(valid_589418, JBool, required = false,
                                 default = newJBool(true))
  if valid_589418 != nil:
    section.add "prettyPrint", valid_589418
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

proc call*(call_589420: Call_VaultMattersSavedQueriesCreate_589404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a saved query.
  ## 
  let valid = call_589420.validator(path, query, header, formData, body)
  let scheme = call_589420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589420.url(scheme.get, call_589420.host, call_589420.base,
                         call_589420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589420, url, valid)

proc call*(call_589421: Call_VaultMattersSavedQueriesCreate_589404;
          matterId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## vaultMattersSavedQueriesCreate
  ## Creates a saved query.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589422 = newJObject()
  var query_589423 = newJObject()
  var body_589424 = newJObject()
  add(query_589423, "upload_protocol", newJString(uploadProtocol))
  add(query_589423, "fields", newJString(fields))
  add(query_589423, "quotaUser", newJString(quotaUser))
  add(query_589423, "alt", newJString(alt))
  add(query_589423, "oauth_token", newJString(oauthToken))
  add(query_589423, "callback", newJString(callback))
  add(query_589423, "access_token", newJString(accessToken))
  add(query_589423, "uploadType", newJString(uploadType))
  add(path_589422, "matterId", newJString(matterId))
  add(query_589423, "key", newJString(key))
  add(query_589423, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589424 = body
  add(query_589423, "prettyPrint", newJBool(prettyPrint))
  result = call_589421.call(path_589422, query_589423, nil, nil, body_589424)

var vaultMattersSavedQueriesCreate* = Call_VaultMattersSavedQueriesCreate_589404(
    name: "vaultMattersSavedQueriesCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/savedQueries",
    validator: validate_VaultMattersSavedQueriesCreate_589405, base: "/",
    url: url_VaultMattersSavedQueriesCreate_589406, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesList_589383 = ref object of OpenApiRestCall_588450
proc url_VaultMattersSavedQueriesList_589385(protocol: Scheme; host: string;
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

proc validate_VaultMattersSavedQueriesList_589384(path: JsonNode; query: JsonNode;
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
  var valid_589386 = path.getOrDefault("matterId")
  valid_589386 = validateParameter(valid_589386, JString, required = true,
                                 default = nil)
  if valid_589386 != nil:
    section.add "matterId", valid_589386
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pagination token as returned in the previous response.
  ## An empty token means start from the beginning.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of saved queries to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589387 = query.getOrDefault("upload_protocol")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "upload_protocol", valid_589387
  var valid_589388 = query.getOrDefault("fields")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "fields", valid_589388
  var valid_589389 = query.getOrDefault("pageToken")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "pageToken", valid_589389
  var valid_589390 = query.getOrDefault("quotaUser")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "quotaUser", valid_589390
  var valid_589391 = query.getOrDefault("alt")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = newJString("json"))
  if valid_589391 != nil:
    section.add "alt", valid_589391
  var valid_589392 = query.getOrDefault("oauth_token")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "oauth_token", valid_589392
  var valid_589393 = query.getOrDefault("callback")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "callback", valid_589393
  var valid_589394 = query.getOrDefault("access_token")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "access_token", valid_589394
  var valid_589395 = query.getOrDefault("uploadType")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "uploadType", valid_589395
  var valid_589396 = query.getOrDefault("key")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "key", valid_589396
  var valid_589397 = query.getOrDefault("$.xgafv")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = newJString("1"))
  if valid_589397 != nil:
    section.add "$.xgafv", valid_589397
  var valid_589398 = query.getOrDefault("pageSize")
  valid_589398 = validateParameter(valid_589398, JInt, required = false, default = nil)
  if valid_589398 != nil:
    section.add "pageSize", valid_589398
  var valid_589399 = query.getOrDefault("prettyPrint")
  valid_589399 = validateParameter(valid_589399, JBool, required = false,
                                 default = newJBool(true))
  if valid_589399 != nil:
    section.add "prettyPrint", valid_589399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589400: Call_VaultMattersSavedQueriesList_589383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists saved queries within a matter. An empty page token in
  ## ListSavedQueriesResponse denotes no more saved queries to list.
  ## 
  let valid = call_589400.validator(path, query, header, formData, body)
  let scheme = call_589400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589400.url(scheme.get, call_589400.host, call_589400.base,
                         call_589400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589400, url, valid)

proc call*(call_589401: Call_VaultMattersSavedQueriesList_589383; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## vaultMattersSavedQueriesList
  ## Lists saved queries within a matter. An empty page token in
  ## ListSavedQueriesResponse denotes no more saved queries to list.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pagination token as returned in the previous response.
  ## An empty token means start from the beginning.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter id of the parent matter for which the saved queries are to be
  ## retrieved.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of saved queries to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589402 = newJObject()
  var query_589403 = newJObject()
  add(query_589403, "upload_protocol", newJString(uploadProtocol))
  add(query_589403, "fields", newJString(fields))
  add(query_589403, "pageToken", newJString(pageToken))
  add(query_589403, "quotaUser", newJString(quotaUser))
  add(query_589403, "alt", newJString(alt))
  add(query_589403, "oauth_token", newJString(oauthToken))
  add(query_589403, "callback", newJString(callback))
  add(query_589403, "access_token", newJString(accessToken))
  add(query_589403, "uploadType", newJString(uploadType))
  add(path_589402, "matterId", newJString(matterId))
  add(query_589403, "key", newJString(key))
  add(query_589403, "$.xgafv", newJString(Xgafv))
  add(query_589403, "pageSize", newJInt(pageSize))
  add(query_589403, "prettyPrint", newJBool(prettyPrint))
  result = call_589401.call(path_589402, query_589403, nil, nil, nil)

var vaultMattersSavedQueriesList* = Call_VaultMattersSavedQueriesList_589383(
    name: "vaultMattersSavedQueriesList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/savedQueries",
    validator: validate_VaultMattersSavedQueriesList_589384, base: "/",
    url: url_VaultMattersSavedQueriesList_589385, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesGet_589425 = ref object of OpenApiRestCall_588450
proc url_VaultMattersSavedQueriesGet_589427(protocol: Scheme; host: string;
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

proc validate_VaultMattersSavedQueriesGet_589426(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a saved query by Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## retrieved.
  ##   savedQueryId: JString (required)
  ##               : Id of the saved query to be retrieved.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_589428 = path.getOrDefault("matterId")
  valid_589428 = validateParameter(valid_589428, JString, required = true,
                                 default = nil)
  if valid_589428 != nil:
    section.add "matterId", valid_589428
  var valid_589429 = path.getOrDefault("savedQueryId")
  valid_589429 = validateParameter(valid_589429, JString, required = true,
                                 default = nil)
  if valid_589429 != nil:
    section.add "savedQueryId", valid_589429
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589430 = query.getOrDefault("upload_protocol")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "upload_protocol", valid_589430
  var valid_589431 = query.getOrDefault("fields")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "fields", valid_589431
  var valid_589432 = query.getOrDefault("quotaUser")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "quotaUser", valid_589432
  var valid_589433 = query.getOrDefault("alt")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = newJString("json"))
  if valid_589433 != nil:
    section.add "alt", valid_589433
  var valid_589434 = query.getOrDefault("oauth_token")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "oauth_token", valid_589434
  var valid_589435 = query.getOrDefault("callback")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "callback", valid_589435
  var valid_589436 = query.getOrDefault("access_token")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "access_token", valid_589436
  var valid_589437 = query.getOrDefault("uploadType")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "uploadType", valid_589437
  var valid_589438 = query.getOrDefault("key")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "key", valid_589438
  var valid_589439 = query.getOrDefault("$.xgafv")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = newJString("1"))
  if valid_589439 != nil:
    section.add "$.xgafv", valid_589439
  var valid_589440 = query.getOrDefault("prettyPrint")
  valid_589440 = validateParameter(valid_589440, JBool, required = false,
                                 default = newJBool(true))
  if valid_589440 != nil:
    section.add "prettyPrint", valid_589440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589441: Call_VaultMattersSavedQueriesGet_589425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a saved query by Id.
  ## 
  let valid = call_589441.validator(path, query, header, formData, body)
  let scheme = call_589441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589441.url(scheme.get, call_589441.host, call_589441.base,
                         call_589441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589441, url, valid)

proc call*(call_589442: Call_VaultMattersSavedQueriesGet_589425; matterId: string;
          savedQueryId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## vaultMattersSavedQueriesGet
  ## Retrieves a saved query by Id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## retrieved.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   savedQueryId: string (required)
  ##               : Id of the saved query to be retrieved.
  var path_589443 = newJObject()
  var query_589444 = newJObject()
  add(query_589444, "upload_protocol", newJString(uploadProtocol))
  add(query_589444, "fields", newJString(fields))
  add(query_589444, "quotaUser", newJString(quotaUser))
  add(query_589444, "alt", newJString(alt))
  add(query_589444, "oauth_token", newJString(oauthToken))
  add(query_589444, "callback", newJString(callback))
  add(query_589444, "access_token", newJString(accessToken))
  add(query_589444, "uploadType", newJString(uploadType))
  add(path_589443, "matterId", newJString(matterId))
  add(query_589444, "key", newJString(key))
  add(query_589444, "$.xgafv", newJString(Xgafv))
  add(query_589444, "prettyPrint", newJBool(prettyPrint))
  add(path_589443, "savedQueryId", newJString(savedQueryId))
  result = call_589442.call(path_589443, query_589444, nil, nil, nil)

var vaultMattersSavedQueriesGet* = Call_VaultMattersSavedQueriesGet_589425(
    name: "vaultMattersSavedQueriesGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/savedQueries/{savedQueryId}",
    validator: validate_VaultMattersSavedQueriesGet_589426, base: "/",
    url: url_VaultMattersSavedQueriesGet_589427, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesDelete_589445 = ref object of OpenApiRestCall_588450
proc url_VaultMattersSavedQueriesDelete_589447(protocol: Scheme; host: string;
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

proc validate_VaultMattersSavedQueriesDelete_589446(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a saved query by Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matterId: JString (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## deleted.
  ##   savedQueryId: JString (required)
  ##               : Id of the saved query to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matterId` field"
  var valid_589448 = path.getOrDefault("matterId")
  valid_589448 = validateParameter(valid_589448, JString, required = true,
                                 default = nil)
  if valid_589448 != nil:
    section.add "matterId", valid_589448
  var valid_589449 = path.getOrDefault("savedQueryId")
  valid_589449 = validateParameter(valid_589449, JString, required = true,
                                 default = nil)
  if valid_589449 != nil:
    section.add "savedQueryId", valid_589449
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589450 = query.getOrDefault("upload_protocol")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "upload_protocol", valid_589450
  var valid_589451 = query.getOrDefault("fields")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "fields", valid_589451
  var valid_589452 = query.getOrDefault("quotaUser")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "quotaUser", valid_589452
  var valid_589453 = query.getOrDefault("alt")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = newJString("json"))
  if valid_589453 != nil:
    section.add "alt", valid_589453
  var valid_589454 = query.getOrDefault("oauth_token")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "oauth_token", valid_589454
  var valid_589455 = query.getOrDefault("callback")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "callback", valid_589455
  var valid_589456 = query.getOrDefault("access_token")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "access_token", valid_589456
  var valid_589457 = query.getOrDefault("uploadType")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "uploadType", valid_589457
  var valid_589458 = query.getOrDefault("key")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "key", valid_589458
  var valid_589459 = query.getOrDefault("$.xgafv")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = newJString("1"))
  if valid_589459 != nil:
    section.add "$.xgafv", valid_589459
  var valid_589460 = query.getOrDefault("prettyPrint")
  valid_589460 = validateParameter(valid_589460, JBool, required = false,
                                 default = newJBool(true))
  if valid_589460 != nil:
    section.add "prettyPrint", valid_589460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589461: Call_VaultMattersSavedQueriesDelete_589445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a saved query by Id.
  ## 
  let valid = call_589461.validator(path, query, header, formData, body)
  let scheme = call_589461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589461.url(scheme.get, call_589461.host, call_589461.base,
                         call_589461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589461, url, valid)

proc call*(call_589462: Call_VaultMattersSavedQueriesDelete_589445;
          matterId: string; savedQueryId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## vaultMattersSavedQueriesDelete
  ## Deletes a saved query by Id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter id of the parent matter for which the saved query is to be
  ## deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   savedQueryId: string (required)
  ##               : Id of the saved query to be deleted.
  var path_589463 = newJObject()
  var query_589464 = newJObject()
  add(query_589464, "upload_protocol", newJString(uploadProtocol))
  add(query_589464, "fields", newJString(fields))
  add(query_589464, "quotaUser", newJString(quotaUser))
  add(query_589464, "alt", newJString(alt))
  add(query_589464, "oauth_token", newJString(oauthToken))
  add(query_589464, "callback", newJString(callback))
  add(query_589464, "access_token", newJString(accessToken))
  add(query_589464, "uploadType", newJString(uploadType))
  add(path_589463, "matterId", newJString(matterId))
  add(query_589464, "key", newJString(key))
  add(query_589464, "$.xgafv", newJString(Xgafv))
  add(query_589464, "prettyPrint", newJBool(prettyPrint))
  add(path_589463, "savedQueryId", newJString(savedQueryId))
  result = call_589462.call(path_589463, query_589464, nil, nil, nil)

var vaultMattersSavedQueriesDelete* = Call_VaultMattersSavedQueriesDelete_589445(
    name: "vaultMattersSavedQueriesDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/savedQueries/{savedQueryId}",
    validator: validate_VaultMattersSavedQueriesDelete_589446, base: "/",
    url: url_VaultMattersSavedQueriesDelete_589447, schemes: {Scheme.Https})
type
  Call_VaultMattersAddPermissions_589465 = ref object of OpenApiRestCall_588450
proc url_VaultMattersAddPermissions_589467(protocol: Scheme; host: string;
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

proc validate_VaultMattersAddPermissions_589466(path: JsonNode; query: JsonNode;
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
  var valid_589468 = path.getOrDefault("matterId")
  valid_589468 = validateParameter(valid_589468, JString, required = true,
                                 default = nil)
  if valid_589468 != nil:
    section.add "matterId", valid_589468
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589469 = query.getOrDefault("upload_protocol")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "upload_protocol", valid_589469
  var valid_589470 = query.getOrDefault("fields")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = nil)
  if valid_589470 != nil:
    section.add "fields", valid_589470
  var valid_589471 = query.getOrDefault("quotaUser")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "quotaUser", valid_589471
  var valid_589472 = query.getOrDefault("alt")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = newJString("json"))
  if valid_589472 != nil:
    section.add "alt", valid_589472
  var valid_589473 = query.getOrDefault("oauth_token")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "oauth_token", valid_589473
  var valid_589474 = query.getOrDefault("callback")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "callback", valid_589474
  var valid_589475 = query.getOrDefault("access_token")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "access_token", valid_589475
  var valid_589476 = query.getOrDefault("uploadType")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "uploadType", valid_589476
  var valid_589477 = query.getOrDefault("key")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "key", valid_589477
  var valid_589478 = query.getOrDefault("$.xgafv")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = newJString("1"))
  if valid_589478 != nil:
    section.add "$.xgafv", valid_589478
  var valid_589479 = query.getOrDefault("prettyPrint")
  valid_589479 = validateParameter(valid_589479, JBool, required = false,
                                 default = newJBool(true))
  if valid_589479 != nil:
    section.add "prettyPrint", valid_589479
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

proc call*(call_589481: Call_VaultMattersAddPermissions_589465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an account as a matter collaborator.
  ## 
  let valid = call_589481.validator(path, query, header, formData, body)
  let scheme = call_589481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589481.url(scheme.get, call_589481.host, call_589481.base,
                         call_589481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589481, url, valid)

proc call*(call_589482: Call_VaultMattersAddPermissions_589465; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersAddPermissions
  ## Adds an account as a matter collaborator.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589483 = newJObject()
  var query_589484 = newJObject()
  var body_589485 = newJObject()
  add(query_589484, "upload_protocol", newJString(uploadProtocol))
  add(query_589484, "fields", newJString(fields))
  add(query_589484, "quotaUser", newJString(quotaUser))
  add(query_589484, "alt", newJString(alt))
  add(query_589484, "oauth_token", newJString(oauthToken))
  add(query_589484, "callback", newJString(callback))
  add(query_589484, "access_token", newJString(accessToken))
  add(query_589484, "uploadType", newJString(uploadType))
  add(path_589483, "matterId", newJString(matterId))
  add(query_589484, "key", newJString(key))
  add(query_589484, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589485 = body
  add(query_589484, "prettyPrint", newJBool(prettyPrint))
  result = call_589482.call(path_589483, query_589484, nil, nil, body_589485)

var vaultMattersAddPermissions* = Call_VaultMattersAddPermissions_589465(
    name: "vaultMattersAddPermissions", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:addPermissions",
    validator: validate_VaultMattersAddPermissions_589466, base: "/",
    url: url_VaultMattersAddPermissions_589467, schemes: {Scheme.Https})
type
  Call_VaultMattersClose_589486 = ref object of OpenApiRestCall_588450
proc url_VaultMattersClose_589488(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersClose_589487(path: JsonNode; query: JsonNode;
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
  var valid_589489 = path.getOrDefault("matterId")
  valid_589489 = validateParameter(valid_589489, JString, required = true,
                                 default = nil)
  if valid_589489 != nil:
    section.add "matterId", valid_589489
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589490 = query.getOrDefault("upload_protocol")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "upload_protocol", valid_589490
  var valid_589491 = query.getOrDefault("fields")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "fields", valid_589491
  var valid_589492 = query.getOrDefault("quotaUser")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = nil)
  if valid_589492 != nil:
    section.add "quotaUser", valid_589492
  var valid_589493 = query.getOrDefault("alt")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = newJString("json"))
  if valid_589493 != nil:
    section.add "alt", valid_589493
  var valid_589494 = query.getOrDefault("oauth_token")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "oauth_token", valid_589494
  var valid_589495 = query.getOrDefault("callback")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "callback", valid_589495
  var valid_589496 = query.getOrDefault("access_token")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "access_token", valid_589496
  var valid_589497 = query.getOrDefault("uploadType")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "uploadType", valid_589497
  var valid_589498 = query.getOrDefault("key")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "key", valid_589498
  var valid_589499 = query.getOrDefault("$.xgafv")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = newJString("1"))
  if valid_589499 != nil:
    section.add "$.xgafv", valid_589499
  var valid_589500 = query.getOrDefault("prettyPrint")
  valid_589500 = validateParameter(valid_589500, JBool, required = false,
                                 default = newJBool(true))
  if valid_589500 != nil:
    section.add "prettyPrint", valid_589500
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

proc call*(call_589502: Call_VaultMattersClose_589486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Closes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_589502.validator(path, query, header, formData, body)
  let scheme = call_589502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589502.url(scheme.get, call_589502.host, call_589502.base,
                         call_589502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589502, url, valid)

proc call*(call_589503: Call_VaultMattersClose_589486; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersClose
  ## Closes the specified matter. Returns matter with updated state.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589504 = newJObject()
  var query_589505 = newJObject()
  var body_589506 = newJObject()
  add(query_589505, "upload_protocol", newJString(uploadProtocol))
  add(query_589505, "fields", newJString(fields))
  add(query_589505, "quotaUser", newJString(quotaUser))
  add(query_589505, "alt", newJString(alt))
  add(query_589505, "oauth_token", newJString(oauthToken))
  add(query_589505, "callback", newJString(callback))
  add(query_589505, "access_token", newJString(accessToken))
  add(query_589505, "uploadType", newJString(uploadType))
  add(path_589504, "matterId", newJString(matterId))
  add(query_589505, "key", newJString(key))
  add(query_589505, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589506 = body
  add(query_589505, "prettyPrint", newJBool(prettyPrint))
  result = call_589503.call(path_589504, query_589505, nil, nil, body_589506)

var vaultMattersClose* = Call_VaultMattersClose_589486(name: "vaultMattersClose",
    meth: HttpMethod.HttpPost, host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}:close", validator: validate_VaultMattersClose_589487,
    base: "/", url: url_VaultMattersClose_589488, schemes: {Scheme.Https})
type
  Call_VaultMattersRemovePermissions_589507 = ref object of OpenApiRestCall_588450
proc url_VaultMattersRemovePermissions_589509(protocol: Scheme; host: string;
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

proc validate_VaultMattersRemovePermissions_589508(path: JsonNode; query: JsonNode;
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
  var valid_589510 = path.getOrDefault("matterId")
  valid_589510 = validateParameter(valid_589510, JString, required = true,
                                 default = nil)
  if valid_589510 != nil:
    section.add "matterId", valid_589510
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589511 = query.getOrDefault("upload_protocol")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "upload_protocol", valid_589511
  var valid_589512 = query.getOrDefault("fields")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "fields", valid_589512
  var valid_589513 = query.getOrDefault("quotaUser")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "quotaUser", valid_589513
  var valid_589514 = query.getOrDefault("alt")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = newJString("json"))
  if valid_589514 != nil:
    section.add "alt", valid_589514
  var valid_589515 = query.getOrDefault("oauth_token")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "oauth_token", valid_589515
  var valid_589516 = query.getOrDefault("callback")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = nil)
  if valid_589516 != nil:
    section.add "callback", valid_589516
  var valid_589517 = query.getOrDefault("access_token")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "access_token", valid_589517
  var valid_589518 = query.getOrDefault("uploadType")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "uploadType", valid_589518
  var valid_589519 = query.getOrDefault("key")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "key", valid_589519
  var valid_589520 = query.getOrDefault("$.xgafv")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = newJString("1"))
  if valid_589520 != nil:
    section.add "$.xgafv", valid_589520
  var valid_589521 = query.getOrDefault("prettyPrint")
  valid_589521 = validateParameter(valid_589521, JBool, required = false,
                                 default = newJBool(true))
  if valid_589521 != nil:
    section.add "prettyPrint", valid_589521
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

proc call*(call_589523: Call_VaultMattersRemovePermissions_589507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an account as a matter collaborator.
  ## 
  let valid = call_589523.validator(path, query, header, formData, body)
  let scheme = call_589523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589523.url(scheme.get, call_589523.host, call_589523.base,
                         call_589523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589523, url, valid)

proc call*(call_589524: Call_VaultMattersRemovePermissions_589507;
          matterId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## vaultMattersRemovePermissions
  ## Removes an account as a matter collaborator.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589525 = newJObject()
  var query_589526 = newJObject()
  var body_589527 = newJObject()
  add(query_589526, "upload_protocol", newJString(uploadProtocol))
  add(query_589526, "fields", newJString(fields))
  add(query_589526, "quotaUser", newJString(quotaUser))
  add(query_589526, "alt", newJString(alt))
  add(query_589526, "oauth_token", newJString(oauthToken))
  add(query_589526, "callback", newJString(callback))
  add(query_589526, "access_token", newJString(accessToken))
  add(query_589526, "uploadType", newJString(uploadType))
  add(path_589525, "matterId", newJString(matterId))
  add(query_589526, "key", newJString(key))
  add(query_589526, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589527 = body
  add(query_589526, "prettyPrint", newJBool(prettyPrint))
  result = call_589524.call(path_589525, query_589526, nil, nil, body_589527)

var vaultMattersRemovePermissions* = Call_VaultMattersRemovePermissions_589507(
    name: "vaultMattersRemovePermissions", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}:removePermissions",
    validator: validate_VaultMattersRemovePermissions_589508, base: "/",
    url: url_VaultMattersRemovePermissions_589509, schemes: {Scheme.Https})
type
  Call_VaultMattersReopen_589528 = ref object of OpenApiRestCall_588450
proc url_VaultMattersReopen_589530(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersReopen_589529(path: JsonNode; query: JsonNode;
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
  var valid_589531 = path.getOrDefault("matterId")
  valid_589531 = validateParameter(valid_589531, JString, required = true,
                                 default = nil)
  if valid_589531 != nil:
    section.add "matterId", valid_589531
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589532 = query.getOrDefault("upload_protocol")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = nil)
  if valid_589532 != nil:
    section.add "upload_protocol", valid_589532
  var valid_589533 = query.getOrDefault("fields")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = nil)
  if valid_589533 != nil:
    section.add "fields", valid_589533
  var valid_589534 = query.getOrDefault("quotaUser")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = nil)
  if valid_589534 != nil:
    section.add "quotaUser", valid_589534
  var valid_589535 = query.getOrDefault("alt")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = newJString("json"))
  if valid_589535 != nil:
    section.add "alt", valid_589535
  var valid_589536 = query.getOrDefault("oauth_token")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "oauth_token", valid_589536
  var valid_589537 = query.getOrDefault("callback")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "callback", valid_589537
  var valid_589538 = query.getOrDefault("access_token")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "access_token", valid_589538
  var valid_589539 = query.getOrDefault("uploadType")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "uploadType", valid_589539
  var valid_589540 = query.getOrDefault("key")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "key", valid_589540
  var valid_589541 = query.getOrDefault("$.xgafv")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = newJString("1"))
  if valid_589541 != nil:
    section.add "$.xgafv", valid_589541
  var valid_589542 = query.getOrDefault("prettyPrint")
  valid_589542 = validateParameter(valid_589542, JBool, required = false,
                                 default = newJBool(true))
  if valid_589542 != nil:
    section.add "prettyPrint", valid_589542
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

proc call*(call_589544: Call_VaultMattersReopen_589528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reopens the specified matter. Returns matter with updated state.
  ## 
  let valid = call_589544.validator(path, query, header, formData, body)
  let scheme = call_589544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589544.url(scheme.get, call_589544.host, call_589544.base,
                         call_589544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589544, url, valid)

proc call*(call_589545: Call_VaultMattersReopen_589528; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersReopen
  ## Reopens the specified matter. Returns matter with updated state.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589546 = newJObject()
  var query_589547 = newJObject()
  var body_589548 = newJObject()
  add(query_589547, "upload_protocol", newJString(uploadProtocol))
  add(query_589547, "fields", newJString(fields))
  add(query_589547, "quotaUser", newJString(quotaUser))
  add(query_589547, "alt", newJString(alt))
  add(query_589547, "oauth_token", newJString(oauthToken))
  add(query_589547, "callback", newJString(callback))
  add(query_589547, "access_token", newJString(accessToken))
  add(query_589547, "uploadType", newJString(uploadType))
  add(path_589546, "matterId", newJString(matterId))
  add(query_589547, "key", newJString(key))
  add(query_589547, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589548 = body
  add(query_589547, "prettyPrint", newJBool(prettyPrint))
  result = call_589545.call(path_589546, query_589547, nil, nil, body_589548)

var vaultMattersReopen* = Call_VaultMattersReopen_589528(
    name: "vaultMattersReopen", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:reopen",
    validator: validate_VaultMattersReopen_589529, base: "/",
    url: url_VaultMattersReopen_589530, schemes: {Scheme.Https})
type
  Call_VaultMattersUndelete_589549 = ref object of OpenApiRestCall_588450
proc url_VaultMattersUndelete_589551(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersUndelete_589550(path: JsonNode; query: JsonNode;
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
  var valid_589552 = path.getOrDefault("matterId")
  valid_589552 = validateParameter(valid_589552, JString, required = true,
                                 default = nil)
  if valid_589552 != nil:
    section.add "matterId", valid_589552
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589553 = query.getOrDefault("upload_protocol")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "upload_protocol", valid_589553
  var valid_589554 = query.getOrDefault("fields")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = nil)
  if valid_589554 != nil:
    section.add "fields", valid_589554
  var valid_589555 = query.getOrDefault("quotaUser")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = nil)
  if valid_589555 != nil:
    section.add "quotaUser", valid_589555
  var valid_589556 = query.getOrDefault("alt")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = newJString("json"))
  if valid_589556 != nil:
    section.add "alt", valid_589556
  var valid_589557 = query.getOrDefault("oauth_token")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "oauth_token", valid_589557
  var valid_589558 = query.getOrDefault("callback")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "callback", valid_589558
  var valid_589559 = query.getOrDefault("access_token")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "access_token", valid_589559
  var valid_589560 = query.getOrDefault("uploadType")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "uploadType", valid_589560
  var valid_589561 = query.getOrDefault("key")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "key", valid_589561
  var valid_589562 = query.getOrDefault("$.xgafv")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = newJString("1"))
  if valid_589562 != nil:
    section.add "$.xgafv", valid_589562
  var valid_589563 = query.getOrDefault("prettyPrint")
  valid_589563 = validateParameter(valid_589563, JBool, required = false,
                                 default = newJBool(true))
  if valid_589563 != nil:
    section.add "prettyPrint", valid_589563
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

proc call*(call_589565: Call_VaultMattersUndelete_589549; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undeletes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_589565.validator(path, query, header, formData, body)
  let scheme = call_589565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589565.url(scheme.get, call_589565.host, call_589565.base,
                         call_589565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589565, url, valid)

proc call*(call_589566: Call_VaultMattersUndelete_589549; matterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## vaultMattersUndelete
  ## Undeletes the specified matter. Returns matter with updated state.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   matterId: string (required)
  ##           : The matter ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589567 = newJObject()
  var query_589568 = newJObject()
  var body_589569 = newJObject()
  add(query_589568, "upload_protocol", newJString(uploadProtocol))
  add(query_589568, "fields", newJString(fields))
  add(query_589568, "quotaUser", newJString(quotaUser))
  add(query_589568, "alt", newJString(alt))
  add(query_589568, "oauth_token", newJString(oauthToken))
  add(query_589568, "callback", newJString(callback))
  add(query_589568, "access_token", newJString(accessToken))
  add(query_589568, "uploadType", newJString(uploadType))
  add(path_589567, "matterId", newJString(matterId))
  add(query_589568, "key", newJString(key))
  add(query_589568, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589569 = body
  add(query_589568, "prettyPrint", newJBool(prettyPrint))
  result = call_589566.call(path_589567, query_589568, nil, nil, body_589569)

var vaultMattersUndelete* = Call_VaultMattersUndelete_589549(
    name: "vaultMattersUndelete", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:undelete",
    validator: validate_VaultMattersUndelete_589550, base: "/",
    url: url_VaultMattersUndelete_589551, schemes: {Scheme.Https})
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
