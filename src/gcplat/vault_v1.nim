
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_VaultMattersCreate_579966 = ref object of OpenApiRestCall_579421
proc url_VaultMattersCreate_579968(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VaultMattersCreate_579967(path: JsonNode; query: JsonNode;
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
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

proc call*(call_579981: Call_VaultMattersCreate_579966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new matter with the given name and description. The initial state
  ## is open, and the owner is the method caller. Returns the created matter
  ## with default view.
  ## 
  let valid = call_579981.validator(path, query, header, formData, body)
  let scheme = call_579981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579981.url(scheme.get, call_579981.host, call_579981.base,
                         call_579981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579981, url, valid)

proc call*(call_579982: Call_VaultMattersCreate_579966;
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
  var query_579983 = newJObject()
  var body_579984 = newJObject()
  add(query_579983, "upload_protocol", newJString(uploadProtocol))
  add(query_579983, "fields", newJString(fields))
  add(query_579983, "quotaUser", newJString(quotaUser))
  add(query_579983, "alt", newJString(alt))
  add(query_579983, "oauth_token", newJString(oauthToken))
  add(query_579983, "callback", newJString(callback))
  add(query_579983, "access_token", newJString(accessToken))
  add(query_579983, "uploadType", newJString(uploadType))
  add(query_579983, "key", newJString(key))
  add(query_579983, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579984 = body
  add(query_579983, "prettyPrint", newJBool(prettyPrint))
  result = call_579982.call(nil, query_579983, nil, nil, body_579984)

var vaultMattersCreate* = Call_VaultMattersCreate_579966(
    name: "vaultMattersCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters",
    validator: validate_VaultMattersCreate_579967, base: "/",
    url: url_VaultMattersCreate_579968, schemes: {Scheme.Https})
type
  Call_VaultMattersList_579690 = ref object of OpenApiRestCall_579421
proc url_VaultMattersList_579692(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VaultMattersList_579691(path: JsonNode; query: JsonNode;
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
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("pageToken")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "pageToken", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("view")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_579821 != nil:
    section.add "view", valid_579821
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("callback")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "callback", valid_579824
  var valid_579825 = query.getOrDefault("access_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "access_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("pageSize")
  valid_579829 = validateParameter(valid_579829, JInt, required = false, default = nil)
  if valid_579829 != nil:
    section.add "pageSize", valid_579829
  var valid_579830 = query.getOrDefault("prettyPrint")
  valid_579830 = validateParameter(valid_579830, JBool, required = false,
                                 default = newJBool(true))
  if valid_579830 != nil:
    section.add "prettyPrint", valid_579830
  var valid_579831 = query.getOrDefault("state")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = newJString("STATE_UNSPECIFIED"))
  if valid_579831 != nil:
    section.add "state", valid_579831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579854: Call_VaultMattersList_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matters the user has access to.
  ## 
  let valid = call_579854.validator(path, query, header, formData, body)
  let scheme = call_579854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579854.url(scheme.get, call_579854.host, call_579854.base,
                         call_579854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579854, url, valid)

proc call*(call_579925: Call_VaultMattersList_579690; uploadProtocol: string = "";
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
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "pageToken", newJString(pageToken))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(query_579926, "view", newJString(view))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "pageSize", newJInt(pageSize))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  add(query_579926, "state", newJString(state))
  result = call_579925.call(nil, query_579926, nil, nil, nil)

var vaultMattersList* = Call_VaultMattersList_579690(name: "vaultMattersList",
    meth: HttpMethod.HttpGet, host: "vault.googleapis.com", route: "/v1/matters",
    validator: validate_VaultMattersList_579691, base: "/",
    url: url_VaultMattersList_579692, schemes: {Scheme.Https})
type
  Call_VaultMattersUpdate_580019 = ref object of OpenApiRestCall_579421
proc url_VaultMattersUpdate_580021(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersUpdate_580020(path: JsonNode; query: JsonNode;
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
  var valid_580022 = path.getOrDefault("matterId")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "matterId", valid_580022
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
  var valid_580023 = query.getOrDefault("upload_protocol")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "upload_protocol", valid_580023
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  var valid_580025 = query.getOrDefault("quotaUser")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "quotaUser", valid_580025
  var valid_580026 = query.getOrDefault("alt")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("json"))
  if valid_580026 != nil:
    section.add "alt", valid_580026
  var valid_580027 = query.getOrDefault("oauth_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "oauth_token", valid_580027
  var valid_580028 = query.getOrDefault("callback")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "callback", valid_580028
  var valid_580029 = query.getOrDefault("access_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "access_token", valid_580029
  var valid_580030 = query.getOrDefault("uploadType")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "uploadType", valid_580030
  var valid_580031 = query.getOrDefault("key")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "key", valid_580031
  var valid_580032 = query.getOrDefault("$.xgafv")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("1"))
  if valid_580032 != nil:
    section.add "$.xgafv", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
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

proc call*(call_580035: Call_VaultMattersUpdate_580019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified matter.
  ## This updates only the name and description of the matter, identified by
  ## matter id. Changes to any other fields are ignored.
  ## Returns the default view of the matter.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_VaultMattersUpdate_580019; matterId: string;
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
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  var body_580039 = newJObject()
  add(query_580038, "upload_protocol", newJString(uploadProtocol))
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "callback", newJString(callback))
  add(query_580038, "access_token", newJString(accessToken))
  add(query_580038, "uploadType", newJString(uploadType))
  add(path_580037, "matterId", newJString(matterId))
  add(query_580038, "key", newJString(key))
  add(query_580038, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580039 = body
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, body_580039)

var vaultMattersUpdate* = Call_VaultMattersUpdate_580019(
    name: "vaultMattersUpdate", meth: HttpMethod.HttpPut,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}",
    validator: validate_VaultMattersUpdate_580020, base: "/",
    url: url_VaultMattersUpdate_580021, schemes: {Scheme.Https})
type
  Call_VaultMattersGet_579985 = ref object of OpenApiRestCall_579421
proc url_VaultMattersGet_579987(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersGet_579986(path: JsonNode; query: JsonNode;
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
  var valid_580002 = path.getOrDefault("matterId")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "matterId", valid_580002
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
  var valid_580003 = query.getOrDefault("upload_protocol")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "upload_protocol", valid_580003
  var valid_580004 = query.getOrDefault("fields")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "fields", valid_580004
  var valid_580005 = query.getOrDefault("view")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_580005 != nil:
    section.add "view", valid_580005
  var valid_580006 = query.getOrDefault("quotaUser")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "quotaUser", valid_580006
  var valid_580007 = query.getOrDefault("alt")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("json"))
  if valid_580007 != nil:
    section.add "alt", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("callback")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "callback", valid_580009
  var valid_580010 = query.getOrDefault("access_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "access_token", valid_580010
  var valid_580011 = query.getOrDefault("uploadType")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "uploadType", valid_580011
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("$.xgafv")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("1"))
  if valid_580013 != nil:
    section.add "$.xgafv", valid_580013
  var valid_580014 = query.getOrDefault("prettyPrint")
  valid_580014 = validateParameter(valid_580014, JBool, required = false,
                                 default = newJBool(true))
  if valid_580014 != nil:
    section.add "prettyPrint", valid_580014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580015: Call_VaultMattersGet_579985; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified matter.
  ## 
  let valid = call_580015.validator(path, query, header, formData, body)
  let scheme = call_580015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580015.url(scheme.get, call_580015.host, call_580015.base,
                         call_580015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580015, url, valid)

proc call*(call_580016: Call_VaultMattersGet_579985; matterId: string;
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
  var path_580017 = newJObject()
  var query_580018 = newJObject()
  add(query_580018, "upload_protocol", newJString(uploadProtocol))
  add(query_580018, "fields", newJString(fields))
  add(query_580018, "view", newJString(view))
  add(query_580018, "quotaUser", newJString(quotaUser))
  add(query_580018, "alt", newJString(alt))
  add(query_580018, "oauth_token", newJString(oauthToken))
  add(query_580018, "callback", newJString(callback))
  add(query_580018, "access_token", newJString(accessToken))
  add(query_580018, "uploadType", newJString(uploadType))
  add(path_580017, "matterId", newJString(matterId))
  add(query_580018, "key", newJString(key))
  add(query_580018, "$.xgafv", newJString(Xgafv))
  add(query_580018, "prettyPrint", newJBool(prettyPrint))
  result = call_580016.call(path_580017, query_580018, nil, nil, nil)

var vaultMattersGet* = Call_VaultMattersGet_579985(name: "vaultMattersGet",
    meth: HttpMethod.HttpGet, host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}", validator: validate_VaultMattersGet_579986,
    base: "/", url: url_VaultMattersGet_579987, schemes: {Scheme.Https})
type
  Call_VaultMattersDelete_580040 = ref object of OpenApiRestCall_579421
proc url_VaultMattersDelete_580042(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersDelete_580041(path: JsonNode; query: JsonNode;
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
  var valid_580043 = path.getOrDefault("matterId")
  valid_580043 = validateParameter(valid_580043, JString, required = true,
                                 default = nil)
  if valid_580043 != nil:
    section.add "matterId", valid_580043
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
  var valid_580044 = query.getOrDefault("upload_protocol")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "upload_protocol", valid_580044
  var valid_580045 = query.getOrDefault("fields")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "fields", valid_580045
  var valid_580046 = query.getOrDefault("quotaUser")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "quotaUser", valid_580046
  var valid_580047 = query.getOrDefault("alt")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("json"))
  if valid_580047 != nil:
    section.add "alt", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
  var valid_580049 = query.getOrDefault("callback")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "callback", valid_580049
  var valid_580050 = query.getOrDefault("access_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "access_token", valid_580050
  var valid_580051 = query.getOrDefault("uploadType")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "uploadType", valid_580051
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("$.xgafv")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("1"))
  if valid_580053 != nil:
    section.add "$.xgafv", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580055: Call_VaultMattersDelete_580040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_580055.validator(path, query, header, formData, body)
  let scheme = call_580055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580055.url(scheme.get, call_580055.host, call_580055.base,
                         call_580055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580055, url, valid)

proc call*(call_580056: Call_VaultMattersDelete_580040; matterId: string;
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
  var path_580057 = newJObject()
  var query_580058 = newJObject()
  add(query_580058, "upload_protocol", newJString(uploadProtocol))
  add(query_580058, "fields", newJString(fields))
  add(query_580058, "quotaUser", newJString(quotaUser))
  add(query_580058, "alt", newJString(alt))
  add(query_580058, "oauth_token", newJString(oauthToken))
  add(query_580058, "callback", newJString(callback))
  add(query_580058, "access_token", newJString(accessToken))
  add(query_580058, "uploadType", newJString(uploadType))
  add(path_580057, "matterId", newJString(matterId))
  add(query_580058, "key", newJString(key))
  add(query_580058, "$.xgafv", newJString(Xgafv))
  add(query_580058, "prettyPrint", newJBool(prettyPrint))
  result = call_580056.call(path_580057, query_580058, nil, nil, nil)

var vaultMattersDelete* = Call_VaultMattersDelete_580040(
    name: "vaultMattersDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}",
    validator: validate_VaultMattersDelete_580041, base: "/",
    url: url_VaultMattersDelete_580042, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsCreate_580080 = ref object of OpenApiRestCall_579421
proc url_VaultMattersExportsCreate_580082(protocol: Scheme; host: string;
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

proc validate_VaultMattersExportsCreate_580081(path: JsonNode; query: JsonNode;
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
  var valid_580083 = path.getOrDefault("matterId")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "matterId", valid_580083
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
  var valid_580084 = query.getOrDefault("upload_protocol")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "upload_protocol", valid_580084
  var valid_580085 = query.getOrDefault("fields")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "fields", valid_580085
  var valid_580086 = query.getOrDefault("quotaUser")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "quotaUser", valid_580086
  var valid_580087 = query.getOrDefault("alt")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("json"))
  if valid_580087 != nil:
    section.add "alt", valid_580087
  var valid_580088 = query.getOrDefault("oauth_token")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "oauth_token", valid_580088
  var valid_580089 = query.getOrDefault("callback")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "callback", valid_580089
  var valid_580090 = query.getOrDefault("access_token")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "access_token", valid_580090
  var valid_580091 = query.getOrDefault("uploadType")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "uploadType", valid_580091
  var valid_580092 = query.getOrDefault("key")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "key", valid_580092
  var valid_580093 = query.getOrDefault("$.xgafv")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("1"))
  if valid_580093 != nil:
    section.add "$.xgafv", valid_580093
  var valid_580094 = query.getOrDefault("prettyPrint")
  valid_580094 = validateParameter(valid_580094, JBool, required = false,
                                 default = newJBool(true))
  if valid_580094 != nil:
    section.add "prettyPrint", valid_580094
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

proc call*(call_580096: Call_VaultMattersExportsCreate_580080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an Export.
  ## 
  let valid = call_580096.validator(path, query, header, formData, body)
  let scheme = call_580096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580096.url(scheme.get, call_580096.host, call_580096.base,
                         call_580096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580096, url, valid)

proc call*(call_580097: Call_VaultMattersExportsCreate_580080; matterId: string;
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
  var path_580098 = newJObject()
  var query_580099 = newJObject()
  var body_580100 = newJObject()
  add(query_580099, "upload_protocol", newJString(uploadProtocol))
  add(query_580099, "fields", newJString(fields))
  add(query_580099, "quotaUser", newJString(quotaUser))
  add(query_580099, "alt", newJString(alt))
  add(query_580099, "oauth_token", newJString(oauthToken))
  add(query_580099, "callback", newJString(callback))
  add(query_580099, "access_token", newJString(accessToken))
  add(query_580099, "uploadType", newJString(uploadType))
  add(path_580098, "matterId", newJString(matterId))
  add(query_580099, "key", newJString(key))
  add(query_580099, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580100 = body
  add(query_580099, "prettyPrint", newJBool(prettyPrint))
  result = call_580097.call(path_580098, query_580099, nil, nil, body_580100)

var vaultMattersExportsCreate* = Call_VaultMattersExportsCreate_580080(
    name: "vaultMattersExportsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/exports",
    validator: validate_VaultMattersExportsCreate_580081, base: "/",
    url: url_VaultMattersExportsCreate_580082, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsList_580059 = ref object of OpenApiRestCall_579421
proc url_VaultMattersExportsList_580061(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersExportsList_580060(path: JsonNode; query: JsonNode;
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
  var valid_580062 = path.getOrDefault("matterId")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "matterId", valid_580062
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
  var valid_580063 = query.getOrDefault("upload_protocol")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "upload_protocol", valid_580063
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  var valid_580065 = query.getOrDefault("pageToken")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "pageToken", valid_580065
  var valid_580066 = query.getOrDefault("quotaUser")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "quotaUser", valid_580066
  var valid_580067 = query.getOrDefault("alt")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("json"))
  if valid_580067 != nil:
    section.add "alt", valid_580067
  var valid_580068 = query.getOrDefault("oauth_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "oauth_token", valid_580068
  var valid_580069 = query.getOrDefault("callback")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "callback", valid_580069
  var valid_580070 = query.getOrDefault("access_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "access_token", valid_580070
  var valid_580071 = query.getOrDefault("uploadType")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "uploadType", valid_580071
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("$.xgafv")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("1"))
  if valid_580073 != nil:
    section.add "$.xgafv", valid_580073
  var valid_580074 = query.getOrDefault("pageSize")
  valid_580074 = validateParameter(valid_580074, JInt, required = false, default = nil)
  if valid_580074 != nil:
    section.add "pageSize", valid_580074
  var valid_580075 = query.getOrDefault("prettyPrint")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "prettyPrint", valid_580075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580076: Call_VaultMattersExportsList_580059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists Exports.
  ## 
  let valid = call_580076.validator(path, query, header, formData, body)
  let scheme = call_580076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580076.url(scheme.get, call_580076.host, call_580076.base,
                         call_580076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580076, url, valid)

proc call*(call_580077: Call_VaultMattersExportsList_580059; matterId: string;
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
  var path_580078 = newJObject()
  var query_580079 = newJObject()
  add(query_580079, "upload_protocol", newJString(uploadProtocol))
  add(query_580079, "fields", newJString(fields))
  add(query_580079, "pageToken", newJString(pageToken))
  add(query_580079, "quotaUser", newJString(quotaUser))
  add(query_580079, "alt", newJString(alt))
  add(query_580079, "oauth_token", newJString(oauthToken))
  add(query_580079, "callback", newJString(callback))
  add(query_580079, "access_token", newJString(accessToken))
  add(query_580079, "uploadType", newJString(uploadType))
  add(path_580078, "matterId", newJString(matterId))
  add(query_580079, "key", newJString(key))
  add(query_580079, "$.xgafv", newJString(Xgafv))
  add(query_580079, "pageSize", newJInt(pageSize))
  add(query_580079, "prettyPrint", newJBool(prettyPrint))
  result = call_580077.call(path_580078, query_580079, nil, nil, nil)

var vaultMattersExportsList* = Call_VaultMattersExportsList_580059(
    name: "vaultMattersExportsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/exports",
    validator: validate_VaultMattersExportsList_580060, base: "/",
    url: url_VaultMattersExportsList_580061, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsGet_580101 = ref object of OpenApiRestCall_579421
proc url_VaultMattersExportsGet_580103(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersExportsGet_580102(path: JsonNode; query: JsonNode;
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
  var valid_580104 = path.getOrDefault("exportId")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "exportId", valid_580104
  var valid_580105 = path.getOrDefault("matterId")
  valid_580105 = validateParameter(valid_580105, JString, required = true,
                                 default = nil)
  if valid_580105 != nil:
    section.add "matterId", valid_580105
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
  var valid_580106 = query.getOrDefault("upload_protocol")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "upload_protocol", valid_580106
  var valid_580107 = query.getOrDefault("fields")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fields", valid_580107
  var valid_580108 = query.getOrDefault("quotaUser")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "quotaUser", valid_580108
  var valid_580109 = query.getOrDefault("alt")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("json"))
  if valid_580109 != nil:
    section.add "alt", valid_580109
  var valid_580110 = query.getOrDefault("oauth_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "oauth_token", valid_580110
  var valid_580111 = query.getOrDefault("callback")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "callback", valid_580111
  var valid_580112 = query.getOrDefault("access_token")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "access_token", valid_580112
  var valid_580113 = query.getOrDefault("uploadType")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "uploadType", valid_580113
  var valid_580114 = query.getOrDefault("key")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "key", valid_580114
  var valid_580115 = query.getOrDefault("$.xgafv")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = newJString("1"))
  if valid_580115 != nil:
    section.add "$.xgafv", valid_580115
  var valid_580116 = query.getOrDefault("prettyPrint")
  valid_580116 = validateParameter(valid_580116, JBool, required = false,
                                 default = newJBool(true))
  if valid_580116 != nil:
    section.add "prettyPrint", valid_580116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580117: Call_VaultMattersExportsGet_580101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an Export.
  ## 
  let valid = call_580117.validator(path, query, header, formData, body)
  let scheme = call_580117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580117.url(scheme.get, call_580117.host, call_580117.base,
                         call_580117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580117, url, valid)

proc call*(call_580118: Call_VaultMattersExportsGet_580101; exportId: string;
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
  var path_580119 = newJObject()
  var query_580120 = newJObject()
  add(query_580120, "upload_protocol", newJString(uploadProtocol))
  add(query_580120, "fields", newJString(fields))
  add(query_580120, "quotaUser", newJString(quotaUser))
  add(query_580120, "alt", newJString(alt))
  add(path_580119, "exportId", newJString(exportId))
  add(query_580120, "oauth_token", newJString(oauthToken))
  add(query_580120, "callback", newJString(callback))
  add(query_580120, "access_token", newJString(accessToken))
  add(query_580120, "uploadType", newJString(uploadType))
  add(path_580119, "matterId", newJString(matterId))
  add(query_580120, "key", newJString(key))
  add(query_580120, "$.xgafv", newJString(Xgafv))
  add(query_580120, "prettyPrint", newJBool(prettyPrint))
  result = call_580118.call(path_580119, query_580120, nil, nil, nil)

var vaultMattersExportsGet* = Call_VaultMattersExportsGet_580101(
    name: "vaultMattersExportsGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/exports/{exportId}",
    validator: validate_VaultMattersExportsGet_580102, base: "/",
    url: url_VaultMattersExportsGet_580103, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsDelete_580121 = ref object of OpenApiRestCall_579421
proc url_VaultMattersExportsDelete_580123(protocol: Scheme; host: string;
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

proc validate_VaultMattersExportsDelete_580122(path: JsonNode; query: JsonNode;
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
  var valid_580124 = path.getOrDefault("exportId")
  valid_580124 = validateParameter(valid_580124, JString, required = true,
                                 default = nil)
  if valid_580124 != nil:
    section.add "exportId", valid_580124
  var valid_580125 = path.getOrDefault("matterId")
  valid_580125 = validateParameter(valid_580125, JString, required = true,
                                 default = nil)
  if valid_580125 != nil:
    section.add "matterId", valid_580125
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
  var valid_580126 = query.getOrDefault("upload_protocol")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "upload_protocol", valid_580126
  var valid_580127 = query.getOrDefault("fields")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "fields", valid_580127
  var valid_580128 = query.getOrDefault("quotaUser")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "quotaUser", valid_580128
  var valid_580129 = query.getOrDefault("alt")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = newJString("json"))
  if valid_580129 != nil:
    section.add "alt", valid_580129
  var valid_580130 = query.getOrDefault("oauth_token")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "oauth_token", valid_580130
  var valid_580131 = query.getOrDefault("callback")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "callback", valid_580131
  var valid_580132 = query.getOrDefault("access_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "access_token", valid_580132
  var valid_580133 = query.getOrDefault("uploadType")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "uploadType", valid_580133
  var valid_580134 = query.getOrDefault("key")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "key", valid_580134
  var valid_580135 = query.getOrDefault("$.xgafv")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = newJString("1"))
  if valid_580135 != nil:
    section.add "$.xgafv", valid_580135
  var valid_580136 = query.getOrDefault("prettyPrint")
  valid_580136 = validateParameter(valid_580136, JBool, required = false,
                                 default = newJBool(true))
  if valid_580136 != nil:
    section.add "prettyPrint", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_VaultMattersExportsDelete_580121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Export.
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_VaultMattersExportsDelete_580121; exportId: string;
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
  var path_580139 = newJObject()
  var query_580140 = newJObject()
  add(query_580140, "upload_protocol", newJString(uploadProtocol))
  add(query_580140, "fields", newJString(fields))
  add(query_580140, "quotaUser", newJString(quotaUser))
  add(query_580140, "alt", newJString(alt))
  add(path_580139, "exportId", newJString(exportId))
  add(query_580140, "oauth_token", newJString(oauthToken))
  add(query_580140, "callback", newJString(callback))
  add(query_580140, "access_token", newJString(accessToken))
  add(query_580140, "uploadType", newJString(uploadType))
  add(path_580139, "matterId", newJString(matterId))
  add(query_580140, "key", newJString(key))
  add(query_580140, "$.xgafv", newJString(Xgafv))
  add(query_580140, "prettyPrint", newJBool(prettyPrint))
  result = call_580138.call(path_580139, query_580140, nil, nil, nil)

var vaultMattersExportsDelete* = Call_VaultMattersExportsDelete_580121(
    name: "vaultMattersExportsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/exports/{exportId}",
    validator: validate_VaultMattersExportsDelete_580122, base: "/",
    url: url_VaultMattersExportsDelete_580123, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsCreate_580163 = ref object of OpenApiRestCall_579421
proc url_VaultMattersHoldsCreate_580165(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersHoldsCreate_580164(path: JsonNode; query: JsonNode;
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
  var valid_580166 = path.getOrDefault("matterId")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "matterId", valid_580166
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
  var valid_580167 = query.getOrDefault("upload_protocol")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "upload_protocol", valid_580167
  var valid_580168 = query.getOrDefault("fields")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "fields", valid_580168
  var valid_580169 = query.getOrDefault("quotaUser")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "quotaUser", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("oauth_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "oauth_token", valid_580171
  var valid_580172 = query.getOrDefault("callback")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "callback", valid_580172
  var valid_580173 = query.getOrDefault("access_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "access_token", valid_580173
  var valid_580174 = query.getOrDefault("uploadType")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "uploadType", valid_580174
  var valid_580175 = query.getOrDefault("key")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "key", valid_580175
  var valid_580176 = query.getOrDefault("$.xgafv")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("1"))
  if valid_580176 != nil:
    section.add "$.xgafv", valid_580176
  var valid_580177 = query.getOrDefault("prettyPrint")
  valid_580177 = validateParameter(valid_580177, JBool, required = false,
                                 default = newJBool(true))
  if valid_580177 != nil:
    section.add "prettyPrint", valid_580177
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

proc call*(call_580179: Call_VaultMattersHoldsCreate_580163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a hold in the given matter.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_VaultMattersHoldsCreate_580163; matterId: string;
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
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  var body_580183 = newJObject()
  add(query_580182, "upload_protocol", newJString(uploadProtocol))
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "callback", newJString(callback))
  add(query_580182, "access_token", newJString(accessToken))
  add(query_580182, "uploadType", newJString(uploadType))
  add(path_580181, "matterId", newJString(matterId))
  add(query_580182, "key", newJString(key))
  add(query_580182, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580183 = body
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  result = call_580180.call(path_580181, query_580182, nil, nil, body_580183)

var vaultMattersHoldsCreate* = Call_VaultMattersHoldsCreate_580163(
    name: "vaultMattersHoldsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds",
    validator: validate_VaultMattersHoldsCreate_580164, base: "/",
    url: url_VaultMattersHoldsCreate_580165, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsList_580141 = ref object of OpenApiRestCall_579421
proc url_VaultMattersHoldsList_580143(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersHoldsList_580142(path: JsonNode; query: JsonNode;
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
  var valid_580144 = path.getOrDefault("matterId")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "matterId", valid_580144
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
  var valid_580145 = query.getOrDefault("upload_protocol")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "upload_protocol", valid_580145
  var valid_580146 = query.getOrDefault("fields")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "fields", valid_580146
  var valid_580147 = query.getOrDefault("pageToken")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "pageToken", valid_580147
  var valid_580148 = query.getOrDefault("quotaUser")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "quotaUser", valid_580148
  var valid_580149 = query.getOrDefault("view")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("HOLD_VIEW_UNSPECIFIED"))
  if valid_580149 != nil:
    section.add "view", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("oauth_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "oauth_token", valid_580151
  var valid_580152 = query.getOrDefault("callback")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "callback", valid_580152
  var valid_580153 = query.getOrDefault("access_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "access_token", valid_580153
  var valid_580154 = query.getOrDefault("uploadType")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "uploadType", valid_580154
  var valid_580155 = query.getOrDefault("key")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "key", valid_580155
  var valid_580156 = query.getOrDefault("$.xgafv")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = newJString("1"))
  if valid_580156 != nil:
    section.add "$.xgafv", valid_580156
  var valid_580157 = query.getOrDefault("pageSize")
  valid_580157 = validateParameter(valid_580157, JInt, required = false, default = nil)
  if valid_580157 != nil:
    section.add "pageSize", valid_580157
  var valid_580158 = query.getOrDefault("prettyPrint")
  valid_580158 = validateParameter(valid_580158, JBool, required = false,
                                 default = newJBool(true))
  if valid_580158 != nil:
    section.add "prettyPrint", valid_580158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580159: Call_VaultMattersHoldsList_580141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists holds within a matter. An empty page token in ListHoldsResponse
  ## denotes no more holds to list.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_VaultMattersHoldsList_580141; matterId: string;
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
  var path_580161 = newJObject()
  var query_580162 = newJObject()
  add(query_580162, "upload_protocol", newJString(uploadProtocol))
  add(query_580162, "fields", newJString(fields))
  add(query_580162, "pageToken", newJString(pageToken))
  add(query_580162, "quotaUser", newJString(quotaUser))
  add(query_580162, "view", newJString(view))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "callback", newJString(callback))
  add(query_580162, "access_token", newJString(accessToken))
  add(query_580162, "uploadType", newJString(uploadType))
  add(path_580161, "matterId", newJString(matterId))
  add(query_580162, "key", newJString(key))
  add(query_580162, "$.xgafv", newJString(Xgafv))
  add(query_580162, "pageSize", newJInt(pageSize))
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  result = call_580160.call(path_580161, query_580162, nil, nil, nil)

var vaultMattersHoldsList* = Call_VaultMattersHoldsList_580141(
    name: "vaultMattersHoldsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds",
    validator: validate_VaultMattersHoldsList_580142, base: "/",
    url: url_VaultMattersHoldsList_580143, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsUpdate_580205 = ref object of OpenApiRestCall_579421
proc url_VaultMattersHoldsUpdate_580207(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersHoldsUpdate_580206(path: JsonNode; query: JsonNode;
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
  var valid_580208 = path.getOrDefault("matterId")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = nil)
  if valid_580208 != nil:
    section.add "matterId", valid_580208
  var valid_580209 = path.getOrDefault("holdId")
  valid_580209 = validateParameter(valid_580209, JString, required = true,
                                 default = nil)
  if valid_580209 != nil:
    section.add "holdId", valid_580209
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
  var valid_580210 = query.getOrDefault("upload_protocol")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "upload_protocol", valid_580210
  var valid_580211 = query.getOrDefault("fields")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "fields", valid_580211
  var valid_580212 = query.getOrDefault("quotaUser")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "quotaUser", valid_580212
  var valid_580213 = query.getOrDefault("alt")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("json"))
  if valid_580213 != nil:
    section.add "alt", valid_580213
  var valid_580214 = query.getOrDefault("oauth_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "oauth_token", valid_580214
  var valid_580215 = query.getOrDefault("callback")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "callback", valid_580215
  var valid_580216 = query.getOrDefault("access_token")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "access_token", valid_580216
  var valid_580217 = query.getOrDefault("uploadType")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "uploadType", valid_580217
  var valid_580218 = query.getOrDefault("key")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "key", valid_580218
  var valid_580219 = query.getOrDefault("$.xgafv")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = newJString("1"))
  if valid_580219 != nil:
    section.add "$.xgafv", valid_580219
  var valid_580220 = query.getOrDefault("prettyPrint")
  valid_580220 = validateParameter(valid_580220, JBool, required = false,
                                 default = newJBool(true))
  if valid_580220 != nil:
    section.add "prettyPrint", valid_580220
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

proc call*(call_580222: Call_VaultMattersHoldsUpdate_580205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the OU and/or query parameters of a hold. You cannot add accounts
  ## to a hold that covers an OU, nor can you add OUs to a hold that covers
  ## individual accounts. Accounts listed in the hold will be ignored.
  ## 
  let valid = call_580222.validator(path, query, header, formData, body)
  let scheme = call_580222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580222.url(scheme.get, call_580222.host, call_580222.base,
                         call_580222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580222, url, valid)

proc call*(call_580223: Call_VaultMattersHoldsUpdate_580205; matterId: string;
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
  var path_580224 = newJObject()
  var query_580225 = newJObject()
  var body_580226 = newJObject()
  add(query_580225, "upload_protocol", newJString(uploadProtocol))
  add(query_580225, "fields", newJString(fields))
  add(query_580225, "quotaUser", newJString(quotaUser))
  add(query_580225, "alt", newJString(alt))
  add(query_580225, "oauth_token", newJString(oauthToken))
  add(query_580225, "callback", newJString(callback))
  add(query_580225, "access_token", newJString(accessToken))
  add(query_580225, "uploadType", newJString(uploadType))
  add(path_580224, "matterId", newJString(matterId))
  add(query_580225, "key", newJString(key))
  add(query_580225, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580226 = body
  add(query_580225, "prettyPrint", newJBool(prettyPrint))
  add(path_580224, "holdId", newJString(holdId))
  result = call_580223.call(path_580224, query_580225, nil, nil, body_580226)

var vaultMattersHoldsUpdate* = Call_VaultMattersHoldsUpdate_580205(
    name: "vaultMattersHoldsUpdate", meth: HttpMethod.HttpPut,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsUpdate_580206, base: "/",
    url: url_VaultMattersHoldsUpdate_580207, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsGet_580184 = ref object of OpenApiRestCall_579421
proc url_VaultMattersHoldsGet_580186(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersHoldsGet_580185(path: JsonNode; query: JsonNode;
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
  var valid_580187 = path.getOrDefault("matterId")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "matterId", valid_580187
  var valid_580188 = path.getOrDefault("holdId")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "holdId", valid_580188
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
  var valid_580189 = query.getOrDefault("upload_protocol")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "upload_protocol", valid_580189
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  var valid_580191 = query.getOrDefault("view")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = newJString("HOLD_VIEW_UNSPECIFIED"))
  if valid_580191 != nil:
    section.add "view", valid_580191
  var valid_580192 = query.getOrDefault("quotaUser")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "quotaUser", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("callback")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "callback", valid_580195
  var valid_580196 = query.getOrDefault("access_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "access_token", valid_580196
  var valid_580197 = query.getOrDefault("uploadType")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "uploadType", valid_580197
  var valid_580198 = query.getOrDefault("key")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "key", valid_580198
  var valid_580199 = query.getOrDefault("$.xgafv")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("1"))
  if valid_580199 != nil:
    section.add "$.xgafv", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580201: Call_VaultMattersHoldsGet_580184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a hold by ID.
  ## 
  let valid = call_580201.validator(path, query, header, formData, body)
  let scheme = call_580201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580201.url(scheme.get, call_580201.host, call_580201.base,
                         call_580201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580201, url, valid)

proc call*(call_580202: Call_VaultMattersHoldsGet_580184; matterId: string;
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
  var path_580203 = newJObject()
  var query_580204 = newJObject()
  add(query_580204, "upload_protocol", newJString(uploadProtocol))
  add(query_580204, "fields", newJString(fields))
  add(query_580204, "view", newJString(view))
  add(query_580204, "quotaUser", newJString(quotaUser))
  add(query_580204, "alt", newJString(alt))
  add(query_580204, "oauth_token", newJString(oauthToken))
  add(query_580204, "callback", newJString(callback))
  add(query_580204, "access_token", newJString(accessToken))
  add(query_580204, "uploadType", newJString(uploadType))
  add(path_580203, "matterId", newJString(matterId))
  add(query_580204, "key", newJString(key))
  add(query_580204, "$.xgafv", newJString(Xgafv))
  add(query_580204, "prettyPrint", newJBool(prettyPrint))
  add(path_580203, "holdId", newJString(holdId))
  result = call_580202.call(path_580203, query_580204, nil, nil, nil)

var vaultMattersHoldsGet* = Call_VaultMattersHoldsGet_580184(
    name: "vaultMattersHoldsGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsGet_580185, base: "/",
    url: url_VaultMattersHoldsGet_580186, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsDelete_580227 = ref object of OpenApiRestCall_579421
proc url_VaultMattersHoldsDelete_580229(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersHoldsDelete_580228(path: JsonNode; query: JsonNode;
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
  var valid_580230 = path.getOrDefault("matterId")
  valid_580230 = validateParameter(valid_580230, JString, required = true,
                                 default = nil)
  if valid_580230 != nil:
    section.add "matterId", valid_580230
  var valid_580231 = path.getOrDefault("holdId")
  valid_580231 = validateParameter(valid_580231, JString, required = true,
                                 default = nil)
  if valid_580231 != nil:
    section.add "holdId", valid_580231
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
  var valid_580232 = query.getOrDefault("upload_protocol")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "upload_protocol", valid_580232
  var valid_580233 = query.getOrDefault("fields")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "fields", valid_580233
  var valid_580234 = query.getOrDefault("quotaUser")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "quotaUser", valid_580234
  var valid_580235 = query.getOrDefault("alt")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = newJString("json"))
  if valid_580235 != nil:
    section.add "alt", valid_580235
  var valid_580236 = query.getOrDefault("oauth_token")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "oauth_token", valid_580236
  var valid_580237 = query.getOrDefault("callback")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "callback", valid_580237
  var valid_580238 = query.getOrDefault("access_token")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "access_token", valid_580238
  var valid_580239 = query.getOrDefault("uploadType")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "uploadType", valid_580239
  var valid_580240 = query.getOrDefault("key")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "key", valid_580240
  var valid_580241 = query.getOrDefault("$.xgafv")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = newJString("1"))
  if valid_580241 != nil:
    section.add "$.xgafv", valid_580241
  var valid_580242 = query.getOrDefault("prettyPrint")
  valid_580242 = validateParameter(valid_580242, JBool, required = false,
                                 default = newJBool(true))
  if valid_580242 != nil:
    section.add "prettyPrint", valid_580242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580243: Call_VaultMattersHoldsDelete_580227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a hold by ID. This will release any HeldAccounts on this Hold.
  ## 
  let valid = call_580243.validator(path, query, header, formData, body)
  let scheme = call_580243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580243.url(scheme.get, call_580243.host, call_580243.base,
                         call_580243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580243, url, valid)

proc call*(call_580244: Call_VaultMattersHoldsDelete_580227; matterId: string;
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
  var path_580245 = newJObject()
  var query_580246 = newJObject()
  add(query_580246, "upload_protocol", newJString(uploadProtocol))
  add(query_580246, "fields", newJString(fields))
  add(query_580246, "quotaUser", newJString(quotaUser))
  add(query_580246, "alt", newJString(alt))
  add(query_580246, "oauth_token", newJString(oauthToken))
  add(query_580246, "callback", newJString(callback))
  add(query_580246, "access_token", newJString(accessToken))
  add(query_580246, "uploadType", newJString(uploadType))
  add(path_580245, "matterId", newJString(matterId))
  add(query_580246, "key", newJString(key))
  add(query_580246, "$.xgafv", newJString(Xgafv))
  add(query_580246, "prettyPrint", newJBool(prettyPrint))
  add(path_580245, "holdId", newJString(holdId))
  result = call_580244.call(path_580245, query_580246, nil, nil, nil)

var vaultMattersHoldsDelete* = Call_VaultMattersHoldsDelete_580227(
    name: "vaultMattersHoldsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsDelete_580228, base: "/",
    url: url_VaultMattersHoldsDelete_580229, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsCreate_580267 = ref object of OpenApiRestCall_579421
proc url_VaultMattersHoldsAccountsCreate_580269(protocol: Scheme; host: string;
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

proc validate_VaultMattersHoldsAccountsCreate_580268(path: JsonNode;
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
  var valid_580270 = path.getOrDefault("matterId")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "matterId", valid_580270
  var valid_580271 = path.getOrDefault("holdId")
  valid_580271 = validateParameter(valid_580271, JString, required = true,
                                 default = nil)
  if valid_580271 != nil:
    section.add "holdId", valid_580271
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
  var valid_580272 = query.getOrDefault("upload_protocol")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "upload_protocol", valid_580272
  var valid_580273 = query.getOrDefault("fields")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "fields", valid_580273
  var valid_580274 = query.getOrDefault("quotaUser")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "quotaUser", valid_580274
  var valid_580275 = query.getOrDefault("alt")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("json"))
  if valid_580275 != nil:
    section.add "alt", valid_580275
  var valid_580276 = query.getOrDefault("oauth_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "oauth_token", valid_580276
  var valid_580277 = query.getOrDefault("callback")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "callback", valid_580277
  var valid_580278 = query.getOrDefault("access_token")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "access_token", valid_580278
  var valid_580279 = query.getOrDefault("uploadType")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "uploadType", valid_580279
  var valid_580280 = query.getOrDefault("key")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "key", valid_580280
  var valid_580281 = query.getOrDefault("$.xgafv")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = newJString("1"))
  if valid_580281 != nil:
    section.add "$.xgafv", valid_580281
  var valid_580282 = query.getOrDefault("prettyPrint")
  valid_580282 = validateParameter(valid_580282, JBool, required = false,
                                 default = newJBool(true))
  if valid_580282 != nil:
    section.add "prettyPrint", valid_580282
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

proc call*(call_580284: Call_VaultMattersHoldsAccountsCreate_580267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a HeldAccount to a hold. Accounts can only be added to a hold that
  ## has no held_org_unit set. Attempting to add an account to an OU-based
  ## hold will result in an error.
  ## 
  let valid = call_580284.validator(path, query, header, formData, body)
  let scheme = call_580284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580284.url(scheme.get, call_580284.host, call_580284.base,
                         call_580284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580284, url, valid)

proc call*(call_580285: Call_VaultMattersHoldsAccountsCreate_580267;
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
  var path_580286 = newJObject()
  var query_580287 = newJObject()
  var body_580288 = newJObject()
  add(query_580287, "upload_protocol", newJString(uploadProtocol))
  add(query_580287, "fields", newJString(fields))
  add(query_580287, "quotaUser", newJString(quotaUser))
  add(query_580287, "alt", newJString(alt))
  add(query_580287, "oauth_token", newJString(oauthToken))
  add(query_580287, "callback", newJString(callback))
  add(query_580287, "access_token", newJString(accessToken))
  add(query_580287, "uploadType", newJString(uploadType))
  add(path_580286, "matterId", newJString(matterId))
  add(query_580287, "key", newJString(key))
  add(query_580287, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580288 = body
  add(query_580287, "prettyPrint", newJBool(prettyPrint))
  add(path_580286, "holdId", newJString(holdId))
  result = call_580285.call(path_580286, query_580287, nil, nil, body_580288)

var vaultMattersHoldsAccountsCreate* = Call_VaultMattersHoldsAccountsCreate_580267(
    name: "vaultMattersHoldsAccountsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts",
    validator: validate_VaultMattersHoldsAccountsCreate_580268, base: "/",
    url: url_VaultMattersHoldsAccountsCreate_580269, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsList_580247 = ref object of OpenApiRestCall_579421
proc url_VaultMattersHoldsAccountsList_580249(protocol: Scheme; host: string;
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

proc validate_VaultMattersHoldsAccountsList_580248(path: JsonNode; query: JsonNode;
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
  var valid_580250 = path.getOrDefault("matterId")
  valid_580250 = validateParameter(valid_580250, JString, required = true,
                                 default = nil)
  if valid_580250 != nil:
    section.add "matterId", valid_580250
  var valid_580251 = path.getOrDefault("holdId")
  valid_580251 = validateParameter(valid_580251, JString, required = true,
                                 default = nil)
  if valid_580251 != nil:
    section.add "holdId", valid_580251
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
  var valid_580252 = query.getOrDefault("upload_protocol")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "upload_protocol", valid_580252
  var valid_580253 = query.getOrDefault("fields")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "fields", valid_580253
  var valid_580254 = query.getOrDefault("quotaUser")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "quotaUser", valid_580254
  var valid_580255 = query.getOrDefault("alt")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("json"))
  if valid_580255 != nil:
    section.add "alt", valid_580255
  var valid_580256 = query.getOrDefault("oauth_token")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "oauth_token", valid_580256
  var valid_580257 = query.getOrDefault("callback")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "callback", valid_580257
  var valid_580258 = query.getOrDefault("access_token")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "access_token", valid_580258
  var valid_580259 = query.getOrDefault("uploadType")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "uploadType", valid_580259
  var valid_580260 = query.getOrDefault("key")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "key", valid_580260
  var valid_580261 = query.getOrDefault("$.xgafv")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("1"))
  if valid_580261 != nil:
    section.add "$.xgafv", valid_580261
  var valid_580262 = query.getOrDefault("prettyPrint")
  valid_580262 = validateParameter(valid_580262, JBool, required = false,
                                 default = newJBool(true))
  if valid_580262 != nil:
    section.add "prettyPrint", valid_580262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_VaultMattersHoldsAccountsList_580247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists HeldAccounts for a hold. This will only list individually specified
  ## held accounts. If the hold is on an OU, then use
  ## <a href="https://developers.google.com/admin-sdk/">Admin SDK</a>
  ## to enumerate its members.
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_VaultMattersHoldsAccountsList_580247;
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
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  add(query_580266, "upload_protocol", newJString(uploadProtocol))
  add(query_580266, "fields", newJString(fields))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(query_580266, "callback", newJString(callback))
  add(query_580266, "access_token", newJString(accessToken))
  add(query_580266, "uploadType", newJString(uploadType))
  add(path_580265, "matterId", newJString(matterId))
  add(query_580266, "key", newJString(key))
  add(query_580266, "$.xgafv", newJString(Xgafv))
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  add(path_580265, "holdId", newJString(holdId))
  result = call_580264.call(path_580265, query_580266, nil, nil, nil)

var vaultMattersHoldsAccountsList* = Call_VaultMattersHoldsAccountsList_580247(
    name: "vaultMattersHoldsAccountsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts",
    validator: validate_VaultMattersHoldsAccountsList_580248, base: "/",
    url: url_VaultMattersHoldsAccountsList_580249, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsDelete_580289 = ref object of OpenApiRestCall_579421
proc url_VaultMattersHoldsAccountsDelete_580291(protocol: Scheme; host: string;
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

proc validate_VaultMattersHoldsAccountsDelete_580290(path: JsonNode;
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
  var valid_580292 = path.getOrDefault("accountId")
  valid_580292 = validateParameter(valid_580292, JString, required = true,
                                 default = nil)
  if valid_580292 != nil:
    section.add "accountId", valid_580292
  var valid_580293 = path.getOrDefault("matterId")
  valid_580293 = validateParameter(valid_580293, JString, required = true,
                                 default = nil)
  if valid_580293 != nil:
    section.add "matterId", valid_580293
  var valid_580294 = path.getOrDefault("holdId")
  valid_580294 = validateParameter(valid_580294, JString, required = true,
                                 default = nil)
  if valid_580294 != nil:
    section.add "holdId", valid_580294
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
  var valid_580295 = query.getOrDefault("upload_protocol")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "upload_protocol", valid_580295
  var valid_580296 = query.getOrDefault("fields")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "fields", valid_580296
  var valid_580297 = query.getOrDefault("quotaUser")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "quotaUser", valid_580297
  var valid_580298 = query.getOrDefault("alt")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = newJString("json"))
  if valid_580298 != nil:
    section.add "alt", valid_580298
  var valid_580299 = query.getOrDefault("oauth_token")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "oauth_token", valid_580299
  var valid_580300 = query.getOrDefault("callback")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "callback", valid_580300
  var valid_580301 = query.getOrDefault("access_token")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "access_token", valid_580301
  var valid_580302 = query.getOrDefault("uploadType")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "uploadType", valid_580302
  var valid_580303 = query.getOrDefault("key")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "key", valid_580303
  var valid_580304 = query.getOrDefault("$.xgafv")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("1"))
  if valid_580304 != nil:
    section.add "$.xgafv", valid_580304
  var valid_580305 = query.getOrDefault("prettyPrint")
  valid_580305 = validateParameter(valid_580305, JBool, required = false,
                                 default = newJBool(true))
  if valid_580305 != nil:
    section.add "prettyPrint", valid_580305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580306: Call_VaultMattersHoldsAccountsDelete_580289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a HeldAccount from a hold. If this request leaves the hold with
  ## no held accounts, the hold will not apply to any accounts.
  ## 
  let valid = call_580306.validator(path, query, header, formData, body)
  let scheme = call_580306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580306.url(scheme.get, call_580306.host, call_580306.base,
                         call_580306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580306, url, valid)

proc call*(call_580307: Call_VaultMattersHoldsAccountsDelete_580289;
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
  var path_580308 = newJObject()
  var query_580309 = newJObject()
  add(query_580309, "upload_protocol", newJString(uploadProtocol))
  add(query_580309, "fields", newJString(fields))
  add(query_580309, "quotaUser", newJString(quotaUser))
  add(query_580309, "alt", newJString(alt))
  add(query_580309, "oauth_token", newJString(oauthToken))
  add(query_580309, "callback", newJString(callback))
  add(query_580309, "access_token", newJString(accessToken))
  add(query_580309, "uploadType", newJString(uploadType))
  add(path_580308, "accountId", newJString(accountId))
  add(path_580308, "matterId", newJString(matterId))
  add(query_580309, "key", newJString(key))
  add(query_580309, "$.xgafv", newJString(Xgafv))
  add(query_580309, "prettyPrint", newJBool(prettyPrint))
  add(path_580308, "holdId", newJString(holdId))
  result = call_580307.call(path_580308, query_580309, nil, nil, nil)

var vaultMattersHoldsAccountsDelete* = Call_VaultMattersHoldsAccountsDelete_580289(
    name: "vaultMattersHoldsAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts/{accountId}",
    validator: validate_VaultMattersHoldsAccountsDelete_580290, base: "/",
    url: url_VaultMattersHoldsAccountsDelete_580291, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAddHeldAccounts_580310 = ref object of OpenApiRestCall_579421
proc url_VaultMattersHoldsAddHeldAccounts_580312(protocol: Scheme; host: string;
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

proc validate_VaultMattersHoldsAddHeldAccounts_580311(path: JsonNode;
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
  var valid_580313 = path.getOrDefault("matterId")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "matterId", valid_580313
  var valid_580314 = path.getOrDefault("holdId")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "holdId", valid_580314
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
  var valid_580315 = query.getOrDefault("upload_protocol")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "upload_protocol", valid_580315
  var valid_580316 = query.getOrDefault("fields")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "fields", valid_580316
  var valid_580317 = query.getOrDefault("quotaUser")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "quotaUser", valid_580317
  var valid_580318 = query.getOrDefault("alt")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = newJString("json"))
  if valid_580318 != nil:
    section.add "alt", valid_580318
  var valid_580319 = query.getOrDefault("oauth_token")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "oauth_token", valid_580319
  var valid_580320 = query.getOrDefault("callback")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "callback", valid_580320
  var valid_580321 = query.getOrDefault("access_token")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "access_token", valid_580321
  var valid_580322 = query.getOrDefault("uploadType")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "uploadType", valid_580322
  var valid_580323 = query.getOrDefault("key")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "key", valid_580323
  var valid_580324 = query.getOrDefault("$.xgafv")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = newJString("1"))
  if valid_580324 != nil:
    section.add "$.xgafv", valid_580324
  var valid_580325 = query.getOrDefault("prettyPrint")
  valid_580325 = validateParameter(valid_580325, JBool, required = false,
                                 default = newJBool(true))
  if valid_580325 != nil:
    section.add "prettyPrint", valid_580325
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

proc call*(call_580327: Call_VaultMattersHoldsAddHeldAccounts_580310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds HeldAccounts to a hold. Returns a list of accounts that have been
  ## successfully added. Accounts can only be added to an existing account-based
  ## hold.
  ## 
  let valid = call_580327.validator(path, query, header, formData, body)
  let scheme = call_580327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580327.url(scheme.get, call_580327.host, call_580327.base,
                         call_580327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580327, url, valid)

proc call*(call_580328: Call_VaultMattersHoldsAddHeldAccounts_580310;
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
  var path_580329 = newJObject()
  var query_580330 = newJObject()
  var body_580331 = newJObject()
  add(query_580330, "upload_protocol", newJString(uploadProtocol))
  add(query_580330, "fields", newJString(fields))
  add(query_580330, "quotaUser", newJString(quotaUser))
  add(query_580330, "alt", newJString(alt))
  add(query_580330, "oauth_token", newJString(oauthToken))
  add(query_580330, "callback", newJString(callback))
  add(query_580330, "access_token", newJString(accessToken))
  add(query_580330, "uploadType", newJString(uploadType))
  add(path_580329, "matterId", newJString(matterId))
  add(query_580330, "key", newJString(key))
  add(query_580330, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580331 = body
  add(query_580330, "prettyPrint", newJBool(prettyPrint))
  add(path_580329, "holdId", newJString(holdId))
  result = call_580328.call(path_580329, query_580330, nil, nil, body_580331)

var vaultMattersHoldsAddHeldAccounts* = Call_VaultMattersHoldsAddHeldAccounts_580310(
    name: "vaultMattersHoldsAddHeldAccounts", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}:addHeldAccounts",
    validator: validate_VaultMattersHoldsAddHeldAccounts_580311, base: "/",
    url: url_VaultMattersHoldsAddHeldAccounts_580312, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsRemoveHeldAccounts_580332 = ref object of OpenApiRestCall_579421
proc url_VaultMattersHoldsRemoveHeldAccounts_580334(protocol: Scheme; host: string;
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

proc validate_VaultMattersHoldsRemoveHeldAccounts_580333(path: JsonNode;
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
  var valid_580335 = path.getOrDefault("matterId")
  valid_580335 = validateParameter(valid_580335, JString, required = true,
                                 default = nil)
  if valid_580335 != nil:
    section.add "matterId", valid_580335
  var valid_580336 = path.getOrDefault("holdId")
  valid_580336 = validateParameter(valid_580336, JString, required = true,
                                 default = nil)
  if valid_580336 != nil:
    section.add "holdId", valid_580336
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
  var valid_580337 = query.getOrDefault("upload_protocol")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "upload_protocol", valid_580337
  var valid_580338 = query.getOrDefault("fields")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "fields", valid_580338
  var valid_580339 = query.getOrDefault("quotaUser")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "quotaUser", valid_580339
  var valid_580340 = query.getOrDefault("alt")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = newJString("json"))
  if valid_580340 != nil:
    section.add "alt", valid_580340
  var valid_580341 = query.getOrDefault("oauth_token")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "oauth_token", valid_580341
  var valid_580342 = query.getOrDefault("callback")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "callback", valid_580342
  var valid_580343 = query.getOrDefault("access_token")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "access_token", valid_580343
  var valid_580344 = query.getOrDefault("uploadType")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "uploadType", valid_580344
  var valid_580345 = query.getOrDefault("key")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "key", valid_580345
  var valid_580346 = query.getOrDefault("$.xgafv")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = newJString("1"))
  if valid_580346 != nil:
    section.add "$.xgafv", valid_580346
  var valid_580347 = query.getOrDefault("prettyPrint")
  valid_580347 = validateParameter(valid_580347, JBool, required = false,
                                 default = newJBool(true))
  if valid_580347 != nil:
    section.add "prettyPrint", valid_580347
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

proc call*(call_580349: Call_VaultMattersHoldsRemoveHeldAccounts_580332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes HeldAccounts from a hold. Returns a list of statuses in the same
  ## order as the request. If this request leaves the hold with no held
  ## accounts, the hold will not apply to any accounts.
  ## 
  let valid = call_580349.validator(path, query, header, formData, body)
  let scheme = call_580349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580349.url(scheme.get, call_580349.host, call_580349.base,
                         call_580349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580349, url, valid)

proc call*(call_580350: Call_VaultMattersHoldsRemoveHeldAccounts_580332;
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
  var path_580351 = newJObject()
  var query_580352 = newJObject()
  var body_580353 = newJObject()
  add(query_580352, "upload_protocol", newJString(uploadProtocol))
  add(query_580352, "fields", newJString(fields))
  add(query_580352, "quotaUser", newJString(quotaUser))
  add(query_580352, "alt", newJString(alt))
  add(query_580352, "oauth_token", newJString(oauthToken))
  add(query_580352, "callback", newJString(callback))
  add(query_580352, "access_token", newJString(accessToken))
  add(query_580352, "uploadType", newJString(uploadType))
  add(path_580351, "matterId", newJString(matterId))
  add(query_580352, "key", newJString(key))
  add(query_580352, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580353 = body
  add(query_580352, "prettyPrint", newJBool(prettyPrint))
  add(path_580351, "holdId", newJString(holdId))
  result = call_580350.call(path_580351, query_580352, nil, nil, body_580353)

var vaultMattersHoldsRemoveHeldAccounts* = Call_VaultMattersHoldsRemoveHeldAccounts_580332(
    name: "vaultMattersHoldsRemoveHeldAccounts", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}:removeHeldAccounts",
    validator: validate_VaultMattersHoldsRemoveHeldAccounts_580333, base: "/",
    url: url_VaultMattersHoldsRemoveHeldAccounts_580334, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesCreate_580375 = ref object of OpenApiRestCall_579421
proc url_VaultMattersSavedQueriesCreate_580377(protocol: Scheme; host: string;
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

proc validate_VaultMattersSavedQueriesCreate_580376(path: JsonNode;
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
  var valid_580378 = path.getOrDefault("matterId")
  valid_580378 = validateParameter(valid_580378, JString, required = true,
                                 default = nil)
  if valid_580378 != nil:
    section.add "matterId", valid_580378
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
  var valid_580379 = query.getOrDefault("upload_protocol")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "upload_protocol", valid_580379
  var valid_580380 = query.getOrDefault("fields")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "fields", valid_580380
  var valid_580381 = query.getOrDefault("quotaUser")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "quotaUser", valid_580381
  var valid_580382 = query.getOrDefault("alt")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = newJString("json"))
  if valid_580382 != nil:
    section.add "alt", valid_580382
  var valid_580383 = query.getOrDefault("oauth_token")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "oauth_token", valid_580383
  var valid_580384 = query.getOrDefault("callback")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "callback", valid_580384
  var valid_580385 = query.getOrDefault("access_token")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "access_token", valid_580385
  var valid_580386 = query.getOrDefault("uploadType")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "uploadType", valid_580386
  var valid_580387 = query.getOrDefault("key")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "key", valid_580387
  var valid_580388 = query.getOrDefault("$.xgafv")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("1"))
  if valid_580388 != nil:
    section.add "$.xgafv", valid_580388
  var valid_580389 = query.getOrDefault("prettyPrint")
  valid_580389 = validateParameter(valid_580389, JBool, required = false,
                                 default = newJBool(true))
  if valid_580389 != nil:
    section.add "prettyPrint", valid_580389
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

proc call*(call_580391: Call_VaultMattersSavedQueriesCreate_580375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a saved query.
  ## 
  let valid = call_580391.validator(path, query, header, formData, body)
  let scheme = call_580391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580391.url(scheme.get, call_580391.host, call_580391.base,
                         call_580391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580391, url, valid)

proc call*(call_580392: Call_VaultMattersSavedQueriesCreate_580375;
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
  var path_580393 = newJObject()
  var query_580394 = newJObject()
  var body_580395 = newJObject()
  add(query_580394, "upload_protocol", newJString(uploadProtocol))
  add(query_580394, "fields", newJString(fields))
  add(query_580394, "quotaUser", newJString(quotaUser))
  add(query_580394, "alt", newJString(alt))
  add(query_580394, "oauth_token", newJString(oauthToken))
  add(query_580394, "callback", newJString(callback))
  add(query_580394, "access_token", newJString(accessToken))
  add(query_580394, "uploadType", newJString(uploadType))
  add(path_580393, "matterId", newJString(matterId))
  add(query_580394, "key", newJString(key))
  add(query_580394, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580395 = body
  add(query_580394, "prettyPrint", newJBool(prettyPrint))
  result = call_580392.call(path_580393, query_580394, nil, nil, body_580395)

var vaultMattersSavedQueriesCreate* = Call_VaultMattersSavedQueriesCreate_580375(
    name: "vaultMattersSavedQueriesCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/savedQueries",
    validator: validate_VaultMattersSavedQueriesCreate_580376, base: "/",
    url: url_VaultMattersSavedQueriesCreate_580377, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesList_580354 = ref object of OpenApiRestCall_579421
proc url_VaultMattersSavedQueriesList_580356(protocol: Scheme; host: string;
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

proc validate_VaultMattersSavedQueriesList_580355(path: JsonNode; query: JsonNode;
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
  var valid_580357 = path.getOrDefault("matterId")
  valid_580357 = validateParameter(valid_580357, JString, required = true,
                                 default = nil)
  if valid_580357 != nil:
    section.add "matterId", valid_580357
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
  var valid_580358 = query.getOrDefault("upload_protocol")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "upload_protocol", valid_580358
  var valid_580359 = query.getOrDefault("fields")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "fields", valid_580359
  var valid_580360 = query.getOrDefault("pageToken")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "pageToken", valid_580360
  var valid_580361 = query.getOrDefault("quotaUser")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "quotaUser", valid_580361
  var valid_580362 = query.getOrDefault("alt")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = newJString("json"))
  if valid_580362 != nil:
    section.add "alt", valid_580362
  var valid_580363 = query.getOrDefault("oauth_token")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "oauth_token", valid_580363
  var valid_580364 = query.getOrDefault("callback")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "callback", valid_580364
  var valid_580365 = query.getOrDefault("access_token")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "access_token", valid_580365
  var valid_580366 = query.getOrDefault("uploadType")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "uploadType", valid_580366
  var valid_580367 = query.getOrDefault("key")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "key", valid_580367
  var valid_580368 = query.getOrDefault("$.xgafv")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = newJString("1"))
  if valid_580368 != nil:
    section.add "$.xgafv", valid_580368
  var valid_580369 = query.getOrDefault("pageSize")
  valid_580369 = validateParameter(valid_580369, JInt, required = false, default = nil)
  if valid_580369 != nil:
    section.add "pageSize", valid_580369
  var valid_580370 = query.getOrDefault("prettyPrint")
  valid_580370 = validateParameter(valid_580370, JBool, required = false,
                                 default = newJBool(true))
  if valid_580370 != nil:
    section.add "prettyPrint", valid_580370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580371: Call_VaultMattersSavedQueriesList_580354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists saved queries within a matter. An empty page token in
  ## ListSavedQueriesResponse denotes no more saved queries to list.
  ## 
  let valid = call_580371.validator(path, query, header, formData, body)
  let scheme = call_580371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580371.url(scheme.get, call_580371.host, call_580371.base,
                         call_580371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580371, url, valid)

proc call*(call_580372: Call_VaultMattersSavedQueriesList_580354; matterId: string;
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
  var path_580373 = newJObject()
  var query_580374 = newJObject()
  add(query_580374, "upload_protocol", newJString(uploadProtocol))
  add(query_580374, "fields", newJString(fields))
  add(query_580374, "pageToken", newJString(pageToken))
  add(query_580374, "quotaUser", newJString(quotaUser))
  add(query_580374, "alt", newJString(alt))
  add(query_580374, "oauth_token", newJString(oauthToken))
  add(query_580374, "callback", newJString(callback))
  add(query_580374, "access_token", newJString(accessToken))
  add(query_580374, "uploadType", newJString(uploadType))
  add(path_580373, "matterId", newJString(matterId))
  add(query_580374, "key", newJString(key))
  add(query_580374, "$.xgafv", newJString(Xgafv))
  add(query_580374, "pageSize", newJInt(pageSize))
  add(query_580374, "prettyPrint", newJBool(prettyPrint))
  result = call_580372.call(path_580373, query_580374, nil, nil, nil)

var vaultMattersSavedQueriesList* = Call_VaultMattersSavedQueriesList_580354(
    name: "vaultMattersSavedQueriesList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/savedQueries",
    validator: validate_VaultMattersSavedQueriesList_580355, base: "/",
    url: url_VaultMattersSavedQueriesList_580356, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesGet_580396 = ref object of OpenApiRestCall_579421
proc url_VaultMattersSavedQueriesGet_580398(protocol: Scheme; host: string;
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

proc validate_VaultMattersSavedQueriesGet_580397(path: JsonNode; query: JsonNode;
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
  var valid_580399 = path.getOrDefault("matterId")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "matterId", valid_580399
  var valid_580400 = path.getOrDefault("savedQueryId")
  valid_580400 = validateParameter(valid_580400, JString, required = true,
                                 default = nil)
  if valid_580400 != nil:
    section.add "savedQueryId", valid_580400
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
  var valid_580401 = query.getOrDefault("upload_protocol")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "upload_protocol", valid_580401
  var valid_580402 = query.getOrDefault("fields")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "fields", valid_580402
  var valid_580403 = query.getOrDefault("quotaUser")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "quotaUser", valid_580403
  var valid_580404 = query.getOrDefault("alt")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = newJString("json"))
  if valid_580404 != nil:
    section.add "alt", valid_580404
  var valid_580405 = query.getOrDefault("oauth_token")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "oauth_token", valid_580405
  var valid_580406 = query.getOrDefault("callback")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "callback", valid_580406
  var valid_580407 = query.getOrDefault("access_token")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "access_token", valid_580407
  var valid_580408 = query.getOrDefault("uploadType")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "uploadType", valid_580408
  var valid_580409 = query.getOrDefault("key")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "key", valid_580409
  var valid_580410 = query.getOrDefault("$.xgafv")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = newJString("1"))
  if valid_580410 != nil:
    section.add "$.xgafv", valid_580410
  var valid_580411 = query.getOrDefault("prettyPrint")
  valid_580411 = validateParameter(valid_580411, JBool, required = false,
                                 default = newJBool(true))
  if valid_580411 != nil:
    section.add "prettyPrint", valid_580411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580412: Call_VaultMattersSavedQueriesGet_580396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a saved query by Id.
  ## 
  let valid = call_580412.validator(path, query, header, formData, body)
  let scheme = call_580412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580412.url(scheme.get, call_580412.host, call_580412.base,
                         call_580412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580412, url, valid)

proc call*(call_580413: Call_VaultMattersSavedQueriesGet_580396; matterId: string;
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
  var path_580414 = newJObject()
  var query_580415 = newJObject()
  add(query_580415, "upload_protocol", newJString(uploadProtocol))
  add(query_580415, "fields", newJString(fields))
  add(query_580415, "quotaUser", newJString(quotaUser))
  add(query_580415, "alt", newJString(alt))
  add(query_580415, "oauth_token", newJString(oauthToken))
  add(query_580415, "callback", newJString(callback))
  add(query_580415, "access_token", newJString(accessToken))
  add(query_580415, "uploadType", newJString(uploadType))
  add(path_580414, "matterId", newJString(matterId))
  add(query_580415, "key", newJString(key))
  add(query_580415, "$.xgafv", newJString(Xgafv))
  add(query_580415, "prettyPrint", newJBool(prettyPrint))
  add(path_580414, "savedQueryId", newJString(savedQueryId))
  result = call_580413.call(path_580414, query_580415, nil, nil, nil)

var vaultMattersSavedQueriesGet* = Call_VaultMattersSavedQueriesGet_580396(
    name: "vaultMattersSavedQueriesGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/savedQueries/{savedQueryId}",
    validator: validate_VaultMattersSavedQueriesGet_580397, base: "/",
    url: url_VaultMattersSavedQueriesGet_580398, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesDelete_580416 = ref object of OpenApiRestCall_579421
proc url_VaultMattersSavedQueriesDelete_580418(protocol: Scheme; host: string;
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

proc validate_VaultMattersSavedQueriesDelete_580417(path: JsonNode;
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
  var valid_580419 = path.getOrDefault("matterId")
  valid_580419 = validateParameter(valid_580419, JString, required = true,
                                 default = nil)
  if valid_580419 != nil:
    section.add "matterId", valid_580419
  var valid_580420 = path.getOrDefault("savedQueryId")
  valid_580420 = validateParameter(valid_580420, JString, required = true,
                                 default = nil)
  if valid_580420 != nil:
    section.add "savedQueryId", valid_580420
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
  var valid_580421 = query.getOrDefault("upload_protocol")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "upload_protocol", valid_580421
  var valid_580422 = query.getOrDefault("fields")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "fields", valid_580422
  var valid_580423 = query.getOrDefault("quotaUser")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "quotaUser", valid_580423
  var valid_580424 = query.getOrDefault("alt")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = newJString("json"))
  if valid_580424 != nil:
    section.add "alt", valid_580424
  var valid_580425 = query.getOrDefault("oauth_token")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "oauth_token", valid_580425
  var valid_580426 = query.getOrDefault("callback")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "callback", valid_580426
  var valid_580427 = query.getOrDefault("access_token")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "access_token", valid_580427
  var valid_580428 = query.getOrDefault("uploadType")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "uploadType", valid_580428
  var valid_580429 = query.getOrDefault("key")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "key", valid_580429
  var valid_580430 = query.getOrDefault("$.xgafv")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = newJString("1"))
  if valid_580430 != nil:
    section.add "$.xgafv", valid_580430
  var valid_580431 = query.getOrDefault("prettyPrint")
  valid_580431 = validateParameter(valid_580431, JBool, required = false,
                                 default = newJBool(true))
  if valid_580431 != nil:
    section.add "prettyPrint", valid_580431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580432: Call_VaultMattersSavedQueriesDelete_580416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a saved query by Id.
  ## 
  let valid = call_580432.validator(path, query, header, formData, body)
  let scheme = call_580432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580432.url(scheme.get, call_580432.host, call_580432.base,
                         call_580432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580432, url, valid)

proc call*(call_580433: Call_VaultMattersSavedQueriesDelete_580416;
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
  var path_580434 = newJObject()
  var query_580435 = newJObject()
  add(query_580435, "upload_protocol", newJString(uploadProtocol))
  add(query_580435, "fields", newJString(fields))
  add(query_580435, "quotaUser", newJString(quotaUser))
  add(query_580435, "alt", newJString(alt))
  add(query_580435, "oauth_token", newJString(oauthToken))
  add(query_580435, "callback", newJString(callback))
  add(query_580435, "access_token", newJString(accessToken))
  add(query_580435, "uploadType", newJString(uploadType))
  add(path_580434, "matterId", newJString(matterId))
  add(query_580435, "key", newJString(key))
  add(query_580435, "$.xgafv", newJString(Xgafv))
  add(query_580435, "prettyPrint", newJBool(prettyPrint))
  add(path_580434, "savedQueryId", newJString(savedQueryId))
  result = call_580433.call(path_580434, query_580435, nil, nil, nil)

var vaultMattersSavedQueriesDelete* = Call_VaultMattersSavedQueriesDelete_580416(
    name: "vaultMattersSavedQueriesDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/savedQueries/{savedQueryId}",
    validator: validate_VaultMattersSavedQueriesDelete_580417, base: "/",
    url: url_VaultMattersSavedQueriesDelete_580418, schemes: {Scheme.Https})
type
  Call_VaultMattersAddPermissions_580436 = ref object of OpenApiRestCall_579421
proc url_VaultMattersAddPermissions_580438(protocol: Scheme; host: string;
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

proc validate_VaultMattersAddPermissions_580437(path: JsonNode; query: JsonNode;
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
  var valid_580439 = path.getOrDefault("matterId")
  valid_580439 = validateParameter(valid_580439, JString, required = true,
                                 default = nil)
  if valid_580439 != nil:
    section.add "matterId", valid_580439
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
  var valid_580440 = query.getOrDefault("upload_protocol")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "upload_protocol", valid_580440
  var valid_580441 = query.getOrDefault("fields")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "fields", valid_580441
  var valid_580442 = query.getOrDefault("quotaUser")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "quotaUser", valid_580442
  var valid_580443 = query.getOrDefault("alt")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = newJString("json"))
  if valid_580443 != nil:
    section.add "alt", valid_580443
  var valid_580444 = query.getOrDefault("oauth_token")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "oauth_token", valid_580444
  var valid_580445 = query.getOrDefault("callback")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "callback", valid_580445
  var valid_580446 = query.getOrDefault("access_token")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "access_token", valid_580446
  var valid_580447 = query.getOrDefault("uploadType")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "uploadType", valid_580447
  var valid_580448 = query.getOrDefault("key")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "key", valid_580448
  var valid_580449 = query.getOrDefault("$.xgafv")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = newJString("1"))
  if valid_580449 != nil:
    section.add "$.xgafv", valid_580449
  var valid_580450 = query.getOrDefault("prettyPrint")
  valid_580450 = validateParameter(valid_580450, JBool, required = false,
                                 default = newJBool(true))
  if valid_580450 != nil:
    section.add "prettyPrint", valid_580450
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

proc call*(call_580452: Call_VaultMattersAddPermissions_580436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an account as a matter collaborator.
  ## 
  let valid = call_580452.validator(path, query, header, formData, body)
  let scheme = call_580452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580452.url(scheme.get, call_580452.host, call_580452.base,
                         call_580452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580452, url, valid)

proc call*(call_580453: Call_VaultMattersAddPermissions_580436; matterId: string;
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
  var path_580454 = newJObject()
  var query_580455 = newJObject()
  var body_580456 = newJObject()
  add(query_580455, "upload_protocol", newJString(uploadProtocol))
  add(query_580455, "fields", newJString(fields))
  add(query_580455, "quotaUser", newJString(quotaUser))
  add(query_580455, "alt", newJString(alt))
  add(query_580455, "oauth_token", newJString(oauthToken))
  add(query_580455, "callback", newJString(callback))
  add(query_580455, "access_token", newJString(accessToken))
  add(query_580455, "uploadType", newJString(uploadType))
  add(path_580454, "matterId", newJString(matterId))
  add(query_580455, "key", newJString(key))
  add(query_580455, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580456 = body
  add(query_580455, "prettyPrint", newJBool(prettyPrint))
  result = call_580453.call(path_580454, query_580455, nil, nil, body_580456)

var vaultMattersAddPermissions* = Call_VaultMattersAddPermissions_580436(
    name: "vaultMattersAddPermissions", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:addPermissions",
    validator: validate_VaultMattersAddPermissions_580437, base: "/",
    url: url_VaultMattersAddPermissions_580438, schemes: {Scheme.Https})
type
  Call_VaultMattersClose_580457 = ref object of OpenApiRestCall_579421
proc url_VaultMattersClose_580459(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersClose_580458(path: JsonNode; query: JsonNode;
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
  var valid_580460 = path.getOrDefault("matterId")
  valid_580460 = validateParameter(valid_580460, JString, required = true,
                                 default = nil)
  if valid_580460 != nil:
    section.add "matterId", valid_580460
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
  var valid_580461 = query.getOrDefault("upload_protocol")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "upload_protocol", valid_580461
  var valid_580462 = query.getOrDefault("fields")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "fields", valid_580462
  var valid_580463 = query.getOrDefault("quotaUser")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "quotaUser", valid_580463
  var valid_580464 = query.getOrDefault("alt")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = newJString("json"))
  if valid_580464 != nil:
    section.add "alt", valid_580464
  var valid_580465 = query.getOrDefault("oauth_token")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "oauth_token", valid_580465
  var valid_580466 = query.getOrDefault("callback")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "callback", valid_580466
  var valid_580467 = query.getOrDefault("access_token")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "access_token", valid_580467
  var valid_580468 = query.getOrDefault("uploadType")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "uploadType", valid_580468
  var valid_580469 = query.getOrDefault("key")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "key", valid_580469
  var valid_580470 = query.getOrDefault("$.xgafv")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = newJString("1"))
  if valid_580470 != nil:
    section.add "$.xgafv", valid_580470
  var valid_580471 = query.getOrDefault("prettyPrint")
  valid_580471 = validateParameter(valid_580471, JBool, required = false,
                                 default = newJBool(true))
  if valid_580471 != nil:
    section.add "prettyPrint", valid_580471
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

proc call*(call_580473: Call_VaultMattersClose_580457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Closes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_580473.validator(path, query, header, formData, body)
  let scheme = call_580473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580473.url(scheme.get, call_580473.host, call_580473.base,
                         call_580473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580473, url, valid)

proc call*(call_580474: Call_VaultMattersClose_580457; matterId: string;
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
  var path_580475 = newJObject()
  var query_580476 = newJObject()
  var body_580477 = newJObject()
  add(query_580476, "upload_protocol", newJString(uploadProtocol))
  add(query_580476, "fields", newJString(fields))
  add(query_580476, "quotaUser", newJString(quotaUser))
  add(query_580476, "alt", newJString(alt))
  add(query_580476, "oauth_token", newJString(oauthToken))
  add(query_580476, "callback", newJString(callback))
  add(query_580476, "access_token", newJString(accessToken))
  add(query_580476, "uploadType", newJString(uploadType))
  add(path_580475, "matterId", newJString(matterId))
  add(query_580476, "key", newJString(key))
  add(query_580476, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580477 = body
  add(query_580476, "prettyPrint", newJBool(prettyPrint))
  result = call_580474.call(path_580475, query_580476, nil, nil, body_580477)

var vaultMattersClose* = Call_VaultMattersClose_580457(name: "vaultMattersClose",
    meth: HttpMethod.HttpPost, host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}:close", validator: validate_VaultMattersClose_580458,
    base: "/", url: url_VaultMattersClose_580459, schemes: {Scheme.Https})
type
  Call_VaultMattersRemovePermissions_580478 = ref object of OpenApiRestCall_579421
proc url_VaultMattersRemovePermissions_580480(protocol: Scheme; host: string;
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

proc validate_VaultMattersRemovePermissions_580479(path: JsonNode; query: JsonNode;
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
  var valid_580481 = path.getOrDefault("matterId")
  valid_580481 = validateParameter(valid_580481, JString, required = true,
                                 default = nil)
  if valid_580481 != nil:
    section.add "matterId", valid_580481
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
  var valid_580482 = query.getOrDefault("upload_protocol")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "upload_protocol", valid_580482
  var valid_580483 = query.getOrDefault("fields")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "fields", valid_580483
  var valid_580484 = query.getOrDefault("quotaUser")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "quotaUser", valid_580484
  var valid_580485 = query.getOrDefault("alt")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = newJString("json"))
  if valid_580485 != nil:
    section.add "alt", valid_580485
  var valid_580486 = query.getOrDefault("oauth_token")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "oauth_token", valid_580486
  var valid_580487 = query.getOrDefault("callback")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "callback", valid_580487
  var valid_580488 = query.getOrDefault("access_token")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "access_token", valid_580488
  var valid_580489 = query.getOrDefault("uploadType")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "uploadType", valid_580489
  var valid_580490 = query.getOrDefault("key")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "key", valid_580490
  var valid_580491 = query.getOrDefault("$.xgafv")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = newJString("1"))
  if valid_580491 != nil:
    section.add "$.xgafv", valid_580491
  var valid_580492 = query.getOrDefault("prettyPrint")
  valid_580492 = validateParameter(valid_580492, JBool, required = false,
                                 default = newJBool(true))
  if valid_580492 != nil:
    section.add "prettyPrint", valid_580492
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

proc call*(call_580494: Call_VaultMattersRemovePermissions_580478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an account as a matter collaborator.
  ## 
  let valid = call_580494.validator(path, query, header, formData, body)
  let scheme = call_580494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580494.url(scheme.get, call_580494.host, call_580494.base,
                         call_580494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580494, url, valid)

proc call*(call_580495: Call_VaultMattersRemovePermissions_580478;
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
  var path_580496 = newJObject()
  var query_580497 = newJObject()
  var body_580498 = newJObject()
  add(query_580497, "upload_protocol", newJString(uploadProtocol))
  add(query_580497, "fields", newJString(fields))
  add(query_580497, "quotaUser", newJString(quotaUser))
  add(query_580497, "alt", newJString(alt))
  add(query_580497, "oauth_token", newJString(oauthToken))
  add(query_580497, "callback", newJString(callback))
  add(query_580497, "access_token", newJString(accessToken))
  add(query_580497, "uploadType", newJString(uploadType))
  add(path_580496, "matterId", newJString(matterId))
  add(query_580497, "key", newJString(key))
  add(query_580497, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580498 = body
  add(query_580497, "prettyPrint", newJBool(prettyPrint))
  result = call_580495.call(path_580496, query_580497, nil, nil, body_580498)

var vaultMattersRemovePermissions* = Call_VaultMattersRemovePermissions_580478(
    name: "vaultMattersRemovePermissions", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}:removePermissions",
    validator: validate_VaultMattersRemovePermissions_580479, base: "/",
    url: url_VaultMattersRemovePermissions_580480, schemes: {Scheme.Https})
type
  Call_VaultMattersReopen_580499 = ref object of OpenApiRestCall_579421
proc url_VaultMattersReopen_580501(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersReopen_580500(path: JsonNode; query: JsonNode;
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
  var valid_580502 = path.getOrDefault("matterId")
  valid_580502 = validateParameter(valid_580502, JString, required = true,
                                 default = nil)
  if valid_580502 != nil:
    section.add "matterId", valid_580502
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
  var valid_580503 = query.getOrDefault("upload_protocol")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "upload_protocol", valid_580503
  var valid_580504 = query.getOrDefault("fields")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "fields", valid_580504
  var valid_580505 = query.getOrDefault("quotaUser")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "quotaUser", valid_580505
  var valid_580506 = query.getOrDefault("alt")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = newJString("json"))
  if valid_580506 != nil:
    section.add "alt", valid_580506
  var valid_580507 = query.getOrDefault("oauth_token")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "oauth_token", valid_580507
  var valid_580508 = query.getOrDefault("callback")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "callback", valid_580508
  var valid_580509 = query.getOrDefault("access_token")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "access_token", valid_580509
  var valid_580510 = query.getOrDefault("uploadType")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "uploadType", valid_580510
  var valid_580511 = query.getOrDefault("key")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "key", valid_580511
  var valid_580512 = query.getOrDefault("$.xgafv")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = newJString("1"))
  if valid_580512 != nil:
    section.add "$.xgafv", valid_580512
  var valid_580513 = query.getOrDefault("prettyPrint")
  valid_580513 = validateParameter(valid_580513, JBool, required = false,
                                 default = newJBool(true))
  if valid_580513 != nil:
    section.add "prettyPrint", valid_580513
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

proc call*(call_580515: Call_VaultMattersReopen_580499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reopens the specified matter. Returns matter with updated state.
  ## 
  let valid = call_580515.validator(path, query, header, formData, body)
  let scheme = call_580515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580515.url(scheme.get, call_580515.host, call_580515.base,
                         call_580515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580515, url, valid)

proc call*(call_580516: Call_VaultMattersReopen_580499; matterId: string;
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
  var path_580517 = newJObject()
  var query_580518 = newJObject()
  var body_580519 = newJObject()
  add(query_580518, "upload_protocol", newJString(uploadProtocol))
  add(query_580518, "fields", newJString(fields))
  add(query_580518, "quotaUser", newJString(quotaUser))
  add(query_580518, "alt", newJString(alt))
  add(query_580518, "oauth_token", newJString(oauthToken))
  add(query_580518, "callback", newJString(callback))
  add(query_580518, "access_token", newJString(accessToken))
  add(query_580518, "uploadType", newJString(uploadType))
  add(path_580517, "matterId", newJString(matterId))
  add(query_580518, "key", newJString(key))
  add(query_580518, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580519 = body
  add(query_580518, "prettyPrint", newJBool(prettyPrint))
  result = call_580516.call(path_580517, query_580518, nil, nil, body_580519)

var vaultMattersReopen* = Call_VaultMattersReopen_580499(
    name: "vaultMattersReopen", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:reopen",
    validator: validate_VaultMattersReopen_580500, base: "/",
    url: url_VaultMattersReopen_580501, schemes: {Scheme.Https})
type
  Call_VaultMattersUndelete_580520 = ref object of OpenApiRestCall_579421
proc url_VaultMattersUndelete_580522(protocol: Scheme; host: string; base: string;
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

proc validate_VaultMattersUndelete_580521(path: JsonNode; query: JsonNode;
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
  var valid_580523 = path.getOrDefault("matterId")
  valid_580523 = validateParameter(valid_580523, JString, required = true,
                                 default = nil)
  if valid_580523 != nil:
    section.add "matterId", valid_580523
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
  var valid_580524 = query.getOrDefault("upload_protocol")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "upload_protocol", valid_580524
  var valid_580525 = query.getOrDefault("fields")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "fields", valid_580525
  var valid_580526 = query.getOrDefault("quotaUser")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "quotaUser", valid_580526
  var valid_580527 = query.getOrDefault("alt")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = newJString("json"))
  if valid_580527 != nil:
    section.add "alt", valid_580527
  var valid_580528 = query.getOrDefault("oauth_token")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "oauth_token", valid_580528
  var valid_580529 = query.getOrDefault("callback")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "callback", valid_580529
  var valid_580530 = query.getOrDefault("access_token")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "access_token", valid_580530
  var valid_580531 = query.getOrDefault("uploadType")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "uploadType", valid_580531
  var valid_580532 = query.getOrDefault("key")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "key", valid_580532
  var valid_580533 = query.getOrDefault("$.xgafv")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = newJString("1"))
  if valid_580533 != nil:
    section.add "$.xgafv", valid_580533
  var valid_580534 = query.getOrDefault("prettyPrint")
  valid_580534 = validateParameter(valid_580534, JBool, required = false,
                                 default = newJBool(true))
  if valid_580534 != nil:
    section.add "prettyPrint", valid_580534
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

proc call*(call_580536: Call_VaultMattersUndelete_580520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undeletes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_580536.validator(path, query, header, formData, body)
  let scheme = call_580536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580536.url(scheme.get, call_580536.host, call_580536.base,
                         call_580536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580536, url, valid)

proc call*(call_580537: Call_VaultMattersUndelete_580520; matterId: string;
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
  var path_580538 = newJObject()
  var query_580539 = newJObject()
  var body_580540 = newJObject()
  add(query_580539, "upload_protocol", newJString(uploadProtocol))
  add(query_580539, "fields", newJString(fields))
  add(query_580539, "quotaUser", newJString(quotaUser))
  add(query_580539, "alt", newJString(alt))
  add(query_580539, "oauth_token", newJString(oauthToken))
  add(query_580539, "callback", newJString(callback))
  add(query_580539, "access_token", newJString(accessToken))
  add(query_580539, "uploadType", newJString(uploadType))
  add(path_580538, "matterId", newJString(matterId))
  add(query_580539, "key", newJString(key))
  add(query_580539, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580540 = body
  add(query_580539, "prettyPrint", newJBool(prettyPrint))
  result = call_580537.call(path_580538, query_580539, nil, nil, body_580540)

var vaultMattersUndelete* = Call_VaultMattersUndelete_580520(
    name: "vaultMattersUndelete", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:undelete",
    validator: validate_VaultMattersUndelete_580521, base: "/",
    url: url_VaultMattersUndelete_580522, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
