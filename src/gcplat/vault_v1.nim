
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VaultMattersCreate_593966 = ref object of OpenApiRestCall_593421
proc url_VaultMattersCreate_593968(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_VaultMattersCreate_593967(path: JsonNode; query: JsonNode;
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
  var valid_593969 = query.getOrDefault("upload_protocol")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "upload_protocol", valid_593969
  var valid_593970 = query.getOrDefault("fields")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "fields", valid_593970
  var valid_593971 = query.getOrDefault("quotaUser")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "quotaUser", valid_593971
  var valid_593972 = query.getOrDefault("alt")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = newJString("json"))
  if valid_593972 != nil:
    section.add "alt", valid_593972
  var valid_593973 = query.getOrDefault("oauth_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "oauth_token", valid_593973
  var valid_593974 = query.getOrDefault("callback")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "callback", valid_593974
  var valid_593975 = query.getOrDefault("access_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "access_token", valid_593975
  var valid_593976 = query.getOrDefault("uploadType")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "uploadType", valid_593976
  var valid_593977 = query.getOrDefault("key")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "key", valid_593977
  var valid_593978 = query.getOrDefault("$.xgafv")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("1"))
  if valid_593978 != nil:
    section.add "$.xgafv", valid_593978
  var valid_593979 = query.getOrDefault("prettyPrint")
  valid_593979 = validateParameter(valid_593979, JBool, required = false,
                                 default = newJBool(true))
  if valid_593979 != nil:
    section.add "prettyPrint", valid_593979
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

proc call*(call_593981: Call_VaultMattersCreate_593966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new matter with the given name and description. The initial state
  ## is open, and the owner is the method caller. Returns the created matter
  ## with default view.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_VaultMattersCreate_593966;
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
  var query_593983 = newJObject()
  var body_593984 = newJObject()
  add(query_593983, "upload_protocol", newJString(uploadProtocol))
  add(query_593983, "fields", newJString(fields))
  add(query_593983, "quotaUser", newJString(quotaUser))
  add(query_593983, "alt", newJString(alt))
  add(query_593983, "oauth_token", newJString(oauthToken))
  add(query_593983, "callback", newJString(callback))
  add(query_593983, "access_token", newJString(accessToken))
  add(query_593983, "uploadType", newJString(uploadType))
  add(query_593983, "key", newJString(key))
  add(query_593983, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593984 = body
  add(query_593983, "prettyPrint", newJBool(prettyPrint))
  result = call_593982.call(nil, query_593983, nil, nil, body_593984)

var vaultMattersCreate* = Call_VaultMattersCreate_593966(
    name: "vaultMattersCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters",
    validator: validate_VaultMattersCreate_593967, base: "/",
    url: url_VaultMattersCreate_593968, schemes: {Scheme.Https})
type
  Call_VaultMattersList_593690 = ref object of OpenApiRestCall_593421
proc url_VaultMattersList_593692(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_VaultMattersList_593691(path: JsonNode; query: JsonNode;
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
  var valid_593804 = query.getOrDefault("upload_protocol")
  valid_593804 = validateParameter(valid_593804, JString, required = false,
                                 default = nil)
  if valid_593804 != nil:
    section.add "upload_protocol", valid_593804
  var valid_593805 = query.getOrDefault("fields")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "fields", valid_593805
  var valid_593806 = query.getOrDefault("pageToken")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "pageToken", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593821 = query.getOrDefault("view")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_593821 != nil:
    section.add "view", valid_593821
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("callback")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "callback", valid_593824
  var valid_593825 = query.getOrDefault("access_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "access_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("pageSize")
  valid_593829 = validateParameter(valid_593829, JInt, required = false, default = nil)
  if valid_593829 != nil:
    section.add "pageSize", valid_593829
  var valid_593830 = query.getOrDefault("prettyPrint")
  valid_593830 = validateParameter(valid_593830, JBool, required = false,
                                 default = newJBool(true))
  if valid_593830 != nil:
    section.add "prettyPrint", valid_593830
  var valid_593831 = query.getOrDefault("state")
  valid_593831 = validateParameter(valid_593831, JString, required = false,
                                 default = newJString("STATE_UNSPECIFIED"))
  if valid_593831 != nil:
    section.add "state", valid_593831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593854: Call_VaultMattersList_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matters the user has access to.
  ## 
  let valid = call_593854.validator(path, query, header, formData, body)
  let scheme = call_593854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593854.url(scheme.get, call_593854.host, call_593854.base,
                         call_593854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593854, url, valid)

proc call*(call_593925: Call_VaultMattersList_593690; uploadProtocol: string = "";
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
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "pageToken", newJString(pageToken))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(query_593926, "view", newJString(view))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "pageSize", newJInt(pageSize))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  add(query_593926, "state", newJString(state))
  result = call_593925.call(nil, query_593926, nil, nil, nil)

var vaultMattersList* = Call_VaultMattersList_593690(name: "vaultMattersList",
    meth: HttpMethod.HttpGet, host: "vault.googleapis.com", route: "/v1/matters",
    validator: validate_VaultMattersList_593691, base: "/",
    url: url_VaultMattersList_593692, schemes: {Scheme.Https})
type
  Call_VaultMattersUpdate_594019 = ref object of OpenApiRestCall_593421
proc url_VaultMattersUpdate_594021(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersUpdate_594020(path: JsonNode; query: JsonNode;
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
  var valid_594022 = path.getOrDefault("matterId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "matterId", valid_594022
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
  var valid_594023 = query.getOrDefault("upload_protocol")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "upload_protocol", valid_594023
  var valid_594024 = query.getOrDefault("fields")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "fields", valid_594024
  var valid_594025 = query.getOrDefault("quotaUser")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "quotaUser", valid_594025
  var valid_594026 = query.getOrDefault("alt")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = newJString("json"))
  if valid_594026 != nil:
    section.add "alt", valid_594026
  var valid_594027 = query.getOrDefault("oauth_token")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "oauth_token", valid_594027
  var valid_594028 = query.getOrDefault("callback")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "callback", valid_594028
  var valid_594029 = query.getOrDefault("access_token")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "access_token", valid_594029
  var valid_594030 = query.getOrDefault("uploadType")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "uploadType", valid_594030
  var valid_594031 = query.getOrDefault("key")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "key", valid_594031
  var valid_594032 = query.getOrDefault("$.xgafv")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = newJString("1"))
  if valid_594032 != nil:
    section.add "$.xgafv", valid_594032
  var valid_594033 = query.getOrDefault("prettyPrint")
  valid_594033 = validateParameter(valid_594033, JBool, required = false,
                                 default = newJBool(true))
  if valid_594033 != nil:
    section.add "prettyPrint", valid_594033
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

proc call*(call_594035: Call_VaultMattersUpdate_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified matter.
  ## This updates only the name and description of the matter, identified by
  ## matter id. Changes to any other fields are ignored.
  ## Returns the default view of the matter.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_VaultMattersUpdate_594019; matterId: string;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  var body_594039 = newJObject()
  add(query_594038, "upload_protocol", newJString(uploadProtocol))
  add(query_594038, "fields", newJString(fields))
  add(query_594038, "quotaUser", newJString(quotaUser))
  add(query_594038, "alt", newJString(alt))
  add(query_594038, "oauth_token", newJString(oauthToken))
  add(query_594038, "callback", newJString(callback))
  add(query_594038, "access_token", newJString(accessToken))
  add(query_594038, "uploadType", newJString(uploadType))
  add(path_594037, "matterId", newJString(matterId))
  add(query_594038, "key", newJString(key))
  add(query_594038, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594039 = body
  add(query_594038, "prettyPrint", newJBool(prettyPrint))
  result = call_594036.call(path_594037, query_594038, nil, nil, body_594039)

var vaultMattersUpdate* = Call_VaultMattersUpdate_594019(
    name: "vaultMattersUpdate", meth: HttpMethod.HttpPut,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}",
    validator: validate_VaultMattersUpdate_594020, base: "/",
    url: url_VaultMattersUpdate_594021, schemes: {Scheme.Https})
type
  Call_VaultMattersGet_593985 = ref object of OpenApiRestCall_593421
proc url_VaultMattersGet_593987(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersGet_593986(path: JsonNode; query: JsonNode;
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
  var valid_594002 = path.getOrDefault("matterId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "matterId", valid_594002
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
  var valid_594003 = query.getOrDefault("upload_protocol")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "upload_protocol", valid_594003
  var valid_594004 = query.getOrDefault("fields")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "fields", valid_594004
  var valid_594005 = query.getOrDefault("view")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_594005 != nil:
    section.add "view", valid_594005
  var valid_594006 = query.getOrDefault("quotaUser")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "quotaUser", valid_594006
  var valid_594007 = query.getOrDefault("alt")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = newJString("json"))
  if valid_594007 != nil:
    section.add "alt", valid_594007
  var valid_594008 = query.getOrDefault("oauth_token")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "oauth_token", valid_594008
  var valid_594009 = query.getOrDefault("callback")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "callback", valid_594009
  var valid_594010 = query.getOrDefault("access_token")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "access_token", valid_594010
  var valid_594011 = query.getOrDefault("uploadType")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "uploadType", valid_594011
  var valid_594012 = query.getOrDefault("key")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "key", valid_594012
  var valid_594013 = query.getOrDefault("$.xgafv")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = newJString("1"))
  if valid_594013 != nil:
    section.add "$.xgafv", valid_594013
  var valid_594014 = query.getOrDefault("prettyPrint")
  valid_594014 = validateParameter(valid_594014, JBool, required = false,
                                 default = newJBool(true))
  if valid_594014 != nil:
    section.add "prettyPrint", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_VaultMattersGet_593985; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified matter.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_VaultMattersGet_593985; matterId: string;
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
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(query_594018, "upload_protocol", newJString(uploadProtocol))
  add(query_594018, "fields", newJString(fields))
  add(query_594018, "view", newJString(view))
  add(query_594018, "quotaUser", newJString(quotaUser))
  add(query_594018, "alt", newJString(alt))
  add(query_594018, "oauth_token", newJString(oauthToken))
  add(query_594018, "callback", newJString(callback))
  add(query_594018, "access_token", newJString(accessToken))
  add(query_594018, "uploadType", newJString(uploadType))
  add(path_594017, "matterId", newJString(matterId))
  add(query_594018, "key", newJString(key))
  add(query_594018, "$.xgafv", newJString(Xgafv))
  add(query_594018, "prettyPrint", newJBool(prettyPrint))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var vaultMattersGet* = Call_VaultMattersGet_593985(name: "vaultMattersGet",
    meth: HttpMethod.HttpGet, host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}", validator: validate_VaultMattersGet_593986,
    base: "/", url: url_VaultMattersGet_593987, schemes: {Scheme.Https})
type
  Call_VaultMattersDelete_594040 = ref object of OpenApiRestCall_593421
proc url_VaultMattersDelete_594042(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "matterId" in path, "`matterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/matters/"),
               (kind: VariableSegment, value: "matterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VaultMattersDelete_594041(path: JsonNode; query: JsonNode;
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
  var valid_594043 = path.getOrDefault("matterId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "matterId", valid_594043
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
  var valid_594044 = query.getOrDefault("upload_protocol")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "upload_protocol", valid_594044
  var valid_594045 = query.getOrDefault("fields")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "fields", valid_594045
  var valid_594046 = query.getOrDefault("quotaUser")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "quotaUser", valid_594046
  var valid_594047 = query.getOrDefault("alt")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = newJString("json"))
  if valid_594047 != nil:
    section.add "alt", valid_594047
  var valid_594048 = query.getOrDefault("oauth_token")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "oauth_token", valid_594048
  var valid_594049 = query.getOrDefault("callback")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "callback", valid_594049
  var valid_594050 = query.getOrDefault("access_token")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "access_token", valid_594050
  var valid_594051 = query.getOrDefault("uploadType")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "uploadType", valid_594051
  var valid_594052 = query.getOrDefault("key")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "key", valid_594052
  var valid_594053 = query.getOrDefault("$.xgafv")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = newJString("1"))
  if valid_594053 != nil:
    section.add "$.xgafv", valid_594053
  var valid_594054 = query.getOrDefault("prettyPrint")
  valid_594054 = validateParameter(valid_594054, JBool, required = false,
                                 default = newJBool(true))
  if valid_594054 != nil:
    section.add "prettyPrint", valid_594054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_VaultMattersDelete_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_VaultMattersDelete_594040; matterId: string;
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
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  add(query_594058, "upload_protocol", newJString(uploadProtocol))
  add(query_594058, "fields", newJString(fields))
  add(query_594058, "quotaUser", newJString(quotaUser))
  add(query_594058, "alt", newJString(alt))
  add(query_594058, "oauth_token", newJString(oauthToken))
  add(query_594058, "callback", newJString(callback))
  add(query_594058, "access_token", newJString(accessToken))
  add(query_594058, "uploadType", newJString(uploadType))
  add(path_594057, "matterId", newJString(matterId))
  add(query_594058, "key", newJString(key))
  add(query_594058, "$.xgafv", newJString(Xgafv))
  add(query_594058, "prettyPrint", newJBool(prettyPrint))
  result = call_594056.call(path_594057, query_594058, nil, nil, nil)

var vaultMattersDelete* = Call_VaultMattersDelete_594040(
    name: "vaultMattersDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}",
    validator: validate_VaultMattersDelete_594041, base: "/",
    url: url_VaultMattersDelete_594042, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsCreate_594080 = ref object of OpenApiRestCall_593421
proc url_VaultMattersExportsCreate_594082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersExportsCreate_594081(path: JsonNode; query: JsonNode;
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
  var valid_594083 = path.getOrDefault("matterId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "matterId", valid_594083
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
  var valid_594084 = query.getOrDefault("upload_protocol")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "upload_protocol", valid_594084
  var valid_594085 = query.getOrDefault("fields")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "fields", valid_594085
  var valid_594086 = query.getOrDefault("quotaUser")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "quotaUser", valid_594086
  var valid_594087 = query.getOrDefault("alt")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = newJString("json"))
  if valid_594087 != nil:
    section.add "alt", valid_594087
  var valid_594088 = query.getOrDefault("oauth_token")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "oauth_token", valid_594088
  var valid_594089 = query.getOrDefault("callback")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "callback", valid_594089
  var valid_594090 = query.getOrDefault("access_token")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "access_token", valid_594090
  var valid_594091 = query.getOrDefault("uploadType")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "uploadType", valid_594091
  var valid_594092 = query.getOrDefault("key")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "key", valid_594092
  var valid_594093 = query.getOrDefault("$.xgafv")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = newJString("1"))
  if valid_594093 != nil:
    section.add "$.xgafv", valid_594093
  var valid_594094 = query.getOrDefault("prettyPrint")
  valid_594094 = validateParameter(valid_594094, JBool, required = false,
                                 default = newJBool(true))
  if valid_594094 != nil:
    section.add "prettyPrint", valid_594094
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

proc call*(call_594096: Call_VaultMattersExportsCreate_594080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an Export.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_VaultMattersExportsCreate_594080; matterId: string;
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
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  var body_594100 = newJObject()
  add(query_594099, "upload_protocol", newJString(uploadProtocol))
  add(query_594099, "fields", newJString(fields))
  add(query_594099, "quotaUser", newJString(quotaUser))
  add(query_594099, "alt", newJString(alt))
  add(query_594099, "oauth_token", newJString(oauthToken))
  add(query_594099, "callback", newJString(callback))
  add(query_594099, "access_token", newJString(accessToken))
  add(query_594099, "uploadType", newJString(uploadType))
  add(path_594098, "matterId", newJString(matterId))
  add(query_594099, "key", newJString(key))
  add(query_594099, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594100 = body
  add(query_594099, "prettyPrint", newJBool(prettyPrint))
  result = call_594097.call(path_594098, query_594099, nil, nil, body_594100)

var vaultMattersExportsCreate* = Call_VaultMattersExportsCreate_594080(
    name: "vaultMattersExportsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/exports",
    validator: validate_VaultMattersExportsCreate_594081, base: "/",
    url: url_VaultMattersExportsCreate_594082, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsList_594059 = ref object of OpenApiRestCall_593421
proc url_VaultMattersExportsList_594061(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersExportsList_594060(path: JsonNode; query: JsonNode;
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
  var valid_594062 = path.getOrDefault("matterId")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "matterId", valid_594062
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
  var valid_594063 = query.getOrDefault("upload_protocol")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "upload_protocol", valid_594063
  var valid_594064 = query.getOrDefault("fields")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "fields", valid_594064
  var valid_594065 = query.getOrDefault("pageToken")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "pageToken", valid_594065
  var valid_594066 = query.getOrDefault("quotaUser")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "quotaUser", valid_594066
  var valid_594067 = query.getOrDefault("alt")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = newJString("json"))
  if valid_594067 != nil:
    section.add "alt", valid_594067
  var valid_594068 = query.getOrDefault("oauth_token")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "oauth_token", valid_594068
  var valid_594069 = query.getOrDefault("callback")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "callback", valid_594069
  var valid_594070 = query.getOrDefault("access_token")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "access_token", valid_594070
  var valid_594071 = query.getOrDefault("uploadType")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "uploadType", valid_594071
  var valid_594072 = query.getOrDefault("key")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "key", valid_594072
  var valid_594073 = query.getOrDefault("$.xgafv")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = newJString("1"))
  if valid_594073 != nil:
    section.add "$.xgafv", valid_594073
  var valid_594074 = query.getOrDefault("pageSize")
  valid_594074 = validateParameter(valid_594074, JInt, required = false, default = nil)
  if valid_594074 != nil:
    section.add "pageSize", valid_594074
  var valid_594075 = query.getOrDefault("prettyPrint")
  valid_594075 = validateParameter(valid_594075, JBool, required = false,
                                 default = newJBool(true))
  if valid_594075 != nil:
    section.add "prettyPrint", valid_594075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594076: Call_VaultMattersExportsList_594059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists Exports.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_VaultMattersExportsList_594059; matterId: string;
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
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  add(query_594079, "upload_protocol", newJString(uploadProtocol))
  add(query_594079, "fields", newJString(fields))
  add(query_594079, "pageToken", newJString(pageToken))
  add(query_594079, "quotaUser", newJString(quotaUser))
  add(query_594079, "alt", newJString(alt))
  add(query_594079, "oauth_token", newJString(oauthToken))
  add(query_594079, "callback", newJString(callback))
  add(query_594079, "access_token", newJString(accessToken))
  add(query_594079, "uploadType", newJString(uploadType))
  add(path_594078, "matterId", newJString(matterId))
  add(query_594079, "key", newJString(key))
  add(query_594079, "$.xgafv", newJString(Xgafv))
  add(query_594079, "pageSize", newJInt(pageSize))
  add(query_594079, "prettyPrint", newJBool(prettyPrint))
  result = call_594077.call(path_594078, query_594079, nil, nil, nil)

var vaultMattersExportsList* = Call_VaultMattersExportsList_594059(
    name: "vaultMattersExportsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/exports",
    validator: validate_VaultMattersExportsList_594060, base: "/",
    url: url_VaultMattersExportsList_594061, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsGet_594101 = ref object of OpenApiRestCall_593421
proc url_VaultMattersExportsGet_594103(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersExportsGet_594102(path: JsonNode; query: JsonNode;
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
  var valid_594104 = path.getOrDefault("exportId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "exportId", valid_594104
  var valid_594105 = path.getOrDefault("matterId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "matterId", valid_594105
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
  var valid_594106 = query.getOrDefault("upload_protocol")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "upload_protocol", valid_594106
  var valid_594107 = query.getOrDefault("fields")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "fields", valid_594107
  var valid_594108 = query.getOrDefault("quotaUser")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "quotaUser", valid_594108
  var valid_594109 = query.getOrDefault("alt")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = newJString("json"))
  if valid_594109 != nil:
    section.add "alt", valid_594109
  var valid_594110 = query.getOrDefault("oauth_token")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "oauth_token", valid_594110
  var valid_594111 = query.getOrDefault("callback")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "callback", valid_594111
  var valid_594112 = query.getOrDefault("access_token")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "access_token", valid_594112
  var valid_594113 = query.getOrDefault("uploadType")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "uploadType", valid_594113
  var valid_594114 = query.getOrDefault("key")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "key", valid_594114
  var valid_594115 = query.getOrDefault("$.xgafv")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = newJString("1"))
  if valid_594115 != nil:
    section.add "$.xgafv", valid_594115
  var valid_594116 = query.getOrDefault("prettyPrint")
  valid_594116 = validateParameter(valid_594116, JBool, required = false,
                                 default = newJBool(true))
  if valid_594116 != nil:
    section.add "prettyPrint", valid_594116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594117: Call_VaultMattersExportsGet_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an Export.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_VaultMattersExportsGet_594101; exportId: string;
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
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  add(query_594120, "upload_protocol", newJString(uploadProtocol))
  add(query_594120, "fields", newJString(fields))
  add(query_594120, "quotaUser", newJString(quotaUser))
  add(query_594120, "alt", newJString(alt))
  add(path_594119, "exportId", newJString(exportId))
  add(query_594120, "oauth_token", newJString(oauthToken))
  add(query_594120, "callback", newJString(callback))
  add(query_594120, "access_token", newJString(accessToken))
  add(query_594120, "uploadType", newJString(uploadType))
  add(path_594119, "matterId", newJString(matterId))
  add(query_594120, "key", newJString(key))
  add(query_594120, "$.xgafv", newJString(Xgafv))
  add(query_594120, "prettyPrint", newJBool(prettyPrint))
  result = call_594118.call(path_594119, query_594120, nil, nil, nil)

var vaultMattersExportsGet* = Call_VaultMattersExportsGet_594101(
    name: "vaultMattersExportsGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/exports/{exportId}",
    validator: validate_VaultMattersExportsGet_594102, base: "/",
    url: url_VaultMattersExportsGet_594103, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsDelete_594121 = ref object of OpenApiRestCall_593421
proc url_VaultMattersExportsDelete_594123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersExportsDelete_594122(path: JsonNode; query: JsonNode;
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
  var valid_594124 = path.getOrDefault("exportId")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "exportId", valid_594124
  var valid_594125 = path.getOrDefault("matterId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "matterId", valid_594125
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
  var valid_594126 = query.getOrDefault("upload_protocol")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "upload_protocol", valid_594126
  var valid_594127 = query.getOrDefault("fields")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "fields", valid_594127
  var valid_594128 = query.getOrDefault("quotaUser")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "quotaUser", valid_594128
  var valid_594129 = query.getOrDefault("alt")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = newJString("json"))
  if valid_594129 != nil:
    section.add "alt", valid_594129
  var valid_594130 = query.getOrDefault("oauth_token")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "oauth_token", valid_594130
  var valid_594131 = query.getOrDefault("callback")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "callback", valid_594131
  var valid_594132 = query.getOrDefault("access_token")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "access_token", valid_594132
  var valid_594133 = query.getOrDefault("uploadType")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "uploadType", valid_594133
  var valid_594134 = query.getOrDefault("key")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "key", valid_594134
  var valid_594135 = query.getOrDefault("$.xgafv")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = newJString("1"))
  if valid_594135 != nil:
    section.add "$.xgafv", valid_594135
  var valid_594136 = query.getOrDefault("prettyPrint")
  valid_594136 = validateParameter(valid_594136, JBool, required = false,
                                 default = newJBool(true))
  if valid_594136 != nil:
    section.add "prettyPrint", valid_594136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594137: Call_VaultMattersExportsDelete_594121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Export.
  ## 
  let valid = call_594137.validator(path, query, header, formData, body)
  let scheme = call_594137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594137.url(scheme.get, call_594137.host, call_594137.base,
                         call_594137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594137, url, valid)

proc call*(call_594138: Call_VaultMattersExportsDelete_594121; exportId: string;
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
  var path_594139 = newJObject()
  var query_594140 = newJObject()
  add(query_594140, "upload_protocol", newJString(uploadProtocol))
  add(query_594140, "fields", newJString(fields))
  add(query_594140, "quotaUser", newJString(quotaUser))
  add(query_594140, "alt", newJString(alt))
  add(path_594139, "exportId", newJString(exportId))
  add(query_594140, "oauth_token", newJString(oauthToken))
  add(query_594140, "callback", newJString(callback))
  add(query_594140, "access_token", newJString(accessToken))
  add(query_594140, "uploadType", newJString(uploadType))
  add(path_594139, "matterId", newJString(matterId))
  add(query_594140, "key", newJString(key))
  add(query_594140, "$.xgafv", newJString(Xgafv))
  add(query_594140, "prettyPrint", newJBool(prettyPrint))
  result = call_594138.call(path_594139, query_594140, nil, nil, nil)

var vaultMattersExportsDelete* = Call_VaultMattersExportsDelete_594121(
    name: "vaultMattersExportsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/exports/{exportId}",
    validator: validate_VaultMattersExportsDelete_594122, base: "/",
    url: url_VaultMattersExportsDelete_594123, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsCreate_594163 = ref object of OpenApiRestCall_593421
proc url_VaultMattersHoldsCreate_594165(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersHoldsCreate_594164(path: JsonNode; query: JsonNode;
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
  var valid_594166 = path.getOrDefault("matterId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "matterId", valid_594166
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
  var valid_594167 = query.getOrDefault("upload_protocol")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "upload_protocol", valid_594167
  var valid_594168 = query.getOrDefault("fields")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "fields", valid_594168
  var valid_594169 = query.getOrDefault("quotaUser")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "quotaUser", valid_594169
  var valid_594170 = query.getOrDefault("alt")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = newJString("json"))
  if valid_594170 != nil:
    section.add "alt", valid_594170
  var valid_594171 = query.getOrDefault("oauth_token")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "oauth_token", valid_594171
  var valid_594172 = query.getOrDefault("callback")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "callback", valid_594172
  var valid_594173 = query.getOrDefault("access_token")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "access_token", valid_594173
  var valid_594174 = query.getOrDefault("uploadType")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "uploadType", valid_594174
  var valid_594175 = query.getOrDefault("key")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "key", valid_594175
  var valid_594176 = query.getOrDefault("$.xgafv")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = newJString("1"))
  if valid_594176 != nil:
    section.add "$.xgafv", valid_594176
  var valid_594177 = query.getOrDefault("prettyPrint")
  valid_594177 = validateParameter(valid_594177, JBool, required = false,
                                 default = newJBool(true))
  if valid_594177 != nil:
    section.add "prettyPrint", valid_594177
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

proc call*(call_594179: Call_VaultMattersHoldsCreate_594163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a hold in the given matter.
  ## 
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_VaultMattersHoldsCreate_594163; matterId: string;
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
  var path_594181 = newJObject()
  var query_594182 = newJObject()
  var body_594183 = newJObject()
  add(query_594182, "upload_protocol", newJString(uploadProtocol))
  add(query_594182, "fields", newJString(fields))
  add(query_594182, "quotaUser", newJString(quotaUser))
  add(query_594182, "alt", newJString(alt))
  add(query_594182, "oauth_token", newJString(oauthToken))
  add(query_594182, "callback", newJString(callback))
  add(query_594182, "access_token", newJString(accessToken))
  add(query_594182, "uploadType", newJString(uploadType))
  add(path_594181, "matterId", newJString(matterId))
  add(query_594182, "key", newJString(key))
  add(query_594182, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594183 = body
  add(query_594182, "prettyPrint", newJBool(prettyPrint))
  result = call_594180.call(path_594181, query_594182, nil, nil, body_594183)

var vaultMattersHoldsCreate* = Call_VaultMattersHoldsCreate_594163(
    name: "vaultMattersHoldsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds",
    validator: validate_VaultMattersHoldsCreate_594164, base: "/",
    url: url_VaultMattersHoldsCreate_594165, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsList_594141 = ref object of OpenApiRestCall_593421
proc url_VaultMattersHoldsList_594143(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersHoldsList_594142(path: JsonNode; query: JsonNode;
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
  var valid_594144 = path.getOrDefault("matterId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "matterId", valid_594144
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
  var valid_594145 = query.getOrDefault("upload_protocol")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "upload_protocol", valid_594145
  var valid_594146 = query.getOrDefault("fields")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "fields", valid_594146
  var valid_594147 = query.getOrDefault("pageToken")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "pageToken", valid_594147
  var valid_594148 = query.getOrDefault("quotaUser")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "quotaUser", valid_594148
  var valid_594149 = query.getOrDefault("view")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = newJString("HOLD_VIEW_UNSPECIFIED"))
  if valid_594149 != nil:
    section.add "view", valid_594149
  var valid_594150 = query.getOrDefault("alt")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = newJString("json"))
  if valid_594150 != nil:
    section.add "alt", valid_594150
  var valid_594151 = query.getOrDefault("oauth_token")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "oauth_token", valid_594151
  var valid_594152 = query.getOrDefault("callback")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "callback", valid_594152
  var valid_594153 = query.getOrDefault("access_token")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "access_token", valid_594153
  var valid_594154 = query.getOrDefault("uploadType")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "uploadType", valid_594154
  var valid_594155 = query.getOrDefault("key")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "key", valid_594155
  var valid_594156 = query.getOrDefault("$.xgafv")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = newJString("1"))
  if valid_594156 != nil:
    section.add "$.xgafv", valid_594156
  var valid_594157 = query.getOrDefault("pageSize")
  valid_594157 = validateParameter(valid_594157, JInt, required = false, default = nil)
  if valid_594157 != nil:
    section.add "pageSize", valid_594157
  var valid_594158 = query.getOrDefault("prettyPrint")
  valid_594158 = validateParameter(valid_594158, JBool, required = false,
                                 default = newJBool(true))
  if valid_594158 != nil:
    section.add "prettyPrint", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_VaultMattersHoldsList_594141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists holds within a matter. An empty page token in ListHoldsResponse
  ## denotes no more holds to list.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_VaultMattersHoldsList_594141; matterId: string;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(query_594162, "upload_protocol", newJString(uploadProtocol))
  add(query_594162, "fields", newJString(fields))
  add(query_594162, "pageToken", newJString(pageToken))
  add(query_594162, "quotaUser", newJString(quotaUser))
  add(query_594162, "view", newJString(view))
  add(query_594162, "alt", newJString(alt))
  add(query_594162, "oauth_token", newJString(oauthToken))
  add(query_594162, "callback", newJString(callback))
  add(query_594162, "access_token", newJString(accessToken))
  add(query_594162, "uploadType", newJString(uploadType))
  add(path_594161, "matterId", newJString(matterId))
  add(query_594162, "key", newJString(key))
  add(query_594162, "$.xgafv", newJString(Xgafv))
  add(query_594162, "pageSize", newJInt(pageSize))
  add(query_594162, "prettyPrint", newJBool(prettyPrint))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var vaultMattersHoldsList* = Call_VaultMattersHoldsList_594141(
    name: "vaultMattersHoldsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds",
    validator: validate_VaultMattersHoldsList_594142, base: "/",
    url: url_VaultMattersHoldsList_594143, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsUpdate_594205 = ref object of OpenApiRestCall_593421
proc url_VaultMattersHoldsUpdate_594207(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersHoldsUpdate_594206(path: JsonNode; query: JsonNode;
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
  var valid_594208 = path.getOrDefault("matterId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "matterId", valid_594208
  var valid_594209 = path.getOrDefault("holdId")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "holdId", valid_594209
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
  var valid_594210 = query.getOrDefault("upload_protocol")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "upload_protocol", valid_594210
  var valid_594211 = query.getOrDefault("fields")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "fields", valid_594211
  var valid_594212 = query.getOrDefault("quotaUser")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "quotaUser", valid_594212
  var valid_594213 = query.getOrDefault("alt")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = newJString("json"))
  if valid_594213 != nil:
    section.add "alt", valid_594213
  var valid_594214 = query.getOrDefault("oauth_token")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "oauth_token", valid_594214
  var valid_594215 = query.getOrDefault("callback")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "callback", valid_594215
  var valid_594216 = query.getOrDefault("access_token")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "access_token", valid_594216
  var valid_594217 = query.getOrDefault("uploadType")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "uploadType", valid_594217
  var valid_594218 = query.getOrDefault("key")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "key", valid_594218
  var valid_594219 = query.getOrDefault("$.xgafv")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = newJString("1"))
  if valid_594219 != nil:
    section.add "$.xgafv", valid_594219
  var valid_594220 = query.getOrDefault("prettyPrint")
  valid_594220 = validateParameter(valid_594220, JBool, required = false,
                                 default = newJBool(true))
  if valid_594220 != nil:
    section.add "prettyPrint", valid_594220
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

proc call*(call_594222: Call_VaultMattersHoldsUpdate_594205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the OU and/or query parameters of a hold. You cannot add accounts
  ## to a hold that covers an OU, nor can you add OUs to a hold that covers
  ## individual accounts. Accounts listed in the hold will be ignored.
  ## 
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_VaultMattersHoldsUpdate_594205; matterId: string;
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
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  var body_594226 = newJObject()
  add(query_594225, "upload_protocol", newJString(uploadProtocol))
  add(query_594225, "fields", newJString(fields))
  add(query_594225, "quotaUser", newJString(quotaUser))
  add(query_594225, "alt", newJString(alt))
  add(query_594225, "oauth_token", newJString(oauthToken))
  add(query_594225, "callback", newJString(callback))
  add(query_594225, "access_token", newJString(accessToken))
  add(query_594225, "uploadType", newJString(uploadType))
  add(path_594224, "matterId", newJString(matterId))
  add(query_594225, "key", newJString(key))
  add(query_594225, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594226 = body
  add(query_594225, "prettyPrint", newJBool(prettyPrint))
  add(path_594224, "holdId", newJString(holdId))
  result = call_594223.call(path_594224, query_594225, nil, nil, body_594226)

var vaultMattersHoldsUpdate* = Call_VaultMattersHoldsUpdate_594205(
    name: "vaultMattersHoldsUpdate", meth: HttpMethod.HttpPut,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsUpdate_594206, base: "/",
    url: url_VaultMattersHoldsUpdate_594207, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsGet_594184 = ref object of OpenApiRestCall_593421
proc url_VaultMattersHoldsGet_594186(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersHoldsGet_594185(path: JsonNode; query: JsonNode;
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
  var valid_594187 = path.getOrDefault("matterId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "matterId", valid_594187
  var valid_594188 = path.getOrDefault("holdId")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "holdId", valid_594188
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
  var valid_594189 = query.getOrDefault("upload_protocol")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "upload_protocol", valid_594189
  var valid_594190 = query.getOrDefault("fields")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "fields", valid_594190
  var valid_594191 = query.getOrDefault("view")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = newJString("HOLD_VIEW_UNSPECIFIED"))
  if valid_594191 != nil:
    section.add "view", valid_594191
  var valid_594192 = query.getOrDefault("quotaUser")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "quotaUser", valid_594192
  var valid_594193 = query.getOrDefault("alt")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = newJString("json"))
  if valid_594193 != nil:
    section.add "alt", valid_594193
  var valid_594194 = query.getOrDefault("oauth_token")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "oauth_token", valid_594194
  var valid_594195 = query.getOrDefault("callback")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "callback", valid_594195
  var valid_594196 = query.getOrDefault("access_token")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "access_token", valid_594196
  var valid_594197 = query.getOrDefault("uploadType")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "uploadType", valid_594197
  var valid_594198 = query.getOrDefault("key")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "key", valid_594198
  var valid_594199 = query.getOrDefault("$.xgafv")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = newJString("1"))
  if valid_594199 != nil:
    section.add "$.xgafv", valid_594199
  var valid_594200 = query.getOrDefault("prettyPrint")
  valid_594200 = validateParameter(valid_594200, JBool, required = false,
                                 default = newJBool(true))
  if valid_594200 != nil:
    section.add "prettyPrint", valid_594200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594201: Call_VaultMattersHoldsGet_594184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a hold by ID.
  ## 
  let valid = call_594201.validator(path, query, header, formData, body)
  let scheme = call_594201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594201.url(scheme.get, call_594201.host, call_594201.base,
                         call_594201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594201, url, valid)

proc call*(call_594202: Call_VaultMattersHoldsGet_594184; matterId: string;
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
  var path_594203 = newJObject()
  var query_594204 = newJObject()
  add(query_594204, "upload_protocol", newJString(uploadProtocol))
  add(query_594204, "fields", newJString(fields))
  add(query_594204, "view", newJString(view))
  add(query_594204, "quotaUser", newJString(quotaUser))
  add(query_594204, "alt", newJString(alt))
  add(query_594204, "oauth_token", newJString(oauthToken))
  add(query_594204, "callback", newJString(callback))
  add(query_594204, "access_token", newJString(accessToken))
  add(query_594204, "uploadType", newJString(uploadType))
  add(path_594203, "matterId", newJString(matterId))
  add(query_594204, "key", newJString(key))
  add(query_594204, "$.xgafv", newJString(Xgafv))
  add(query_594204, "prettyPrint", newJBool(prettyPrint))
  add(path_594203, "holdId", newJString(holdId))
  result = call_594202.call(path_594203, query_594204, nil, nil, nil)

var vaultMattersHoldsGet* = Call_VaultMattersHoldsGet_594184(
    name: "vaultMattersHoldsGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsGet_594185, base: "/",
    url: url_VaultMattersHoldsGet_594186, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsDelete_594227 = ref object of OpenApiRestCall_593421
proc url_VaultMattersHoldsDelete_594229(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersHoldsDelete_594228(path: JsonNode; query: JsonNode;
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
  var valid_594230 = path.getOrDefault("matterId")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "matterId", valid_594230
  var valid_594231 = path.getOrDefault("holdId")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "holdId", valid_594231
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
  var valid_594232 = query.getOrDefault("upload_protocol")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "upload_protocol", valid_594232
  var valid_594233 = query.getOrDefault("fields")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "fields", valid_594233
  var valid_594234 = query.getOrDefault("quotaUser")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "quotaUser", valid_594234
  var valid_594235 = query.getOrDefault("alt")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = newJString("json"))
  if valid_594235 != nil:
    section.add "alt", valid_594235
  var valid_594236 = query.getOrDefault("oauth_token")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "oauth_token", valid_594236
  var valid_594237 = query.getOrDefault("callback")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "callback", valid_594237
  var valid_594238 = query.getOrDefault("access_token")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "access_token", valid_594238
  var valid_594239 = query.getOrDefault("uploadType")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "uploadType", valid_594239
  var valid_594240 = query.getOrDefault("key")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "key", valid_594240
  var valid_594241 = query.getOrDefault("$.xgafv")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = newJString("1"))
  if valid_594241 != nil:
    section.add "$.xgafv", valid_594241
  var valid_594242 = query.getOrDefault("prettyPrint")
  valid_594242 = validateParameter(valid_594242, JBool, required = false,
                                 default = newJBool(true))
  if valid_594242 != nil:
    section.add "prettyPrint", valid_594242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594243: Call_VaultMattersHoldsDelete_594227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a hold by ID. This will release any HeldAccounts on this Hold.
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_VaultMattersHoldsDelete_594227; matterId: string;
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
  var path_594245 = newJObject()
  var query_594246 = newJObject()
  add(query_594246, "upload_protocol", newJString(uploadProtocol))
  add(query_594246, "fields", newJString(fields))
  add(query_594246, "quotaUser", newJString(quotaUser))
  add(query_594246, "alt", newJString(alt))
  add(query_594246, "oauth_token", newJString(oauthToken))
  add(query_594246, "callback", newJString(callback))
  add(query_594246, "access_token", newJString(accessToken))
  add(query_594246, "uploadType", newJString(uploadType))
  add(path_594245, "matterId", newJString(matterId))
  add(query_594246, "key", newJString(key))
  add(query_594246, "$.xgafv", newJString(Xgafv))
  add(query_594246, "prettyPrint", newJBool(prettyPrint))
  add(path_594245, "holdId", newJString(holdId))
  result = call_594244.call(path_594245, query_594246, nil, nil, nil)

var vaultMattersHoldsDelete* = Call_VaultMattersHoldsDelete_594227(
    name: "vaultMattersHoldsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsDelete_594228, base: "/",
    url: url_VaultMattersHoldsDelete_594229, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsCreate_594267 = ref object of OpenApiRestCall_593421
proc url_VaultMattersHoldsAccountsCreate_594269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersHoldsAccountsCreate_594268(path: JsonNode;
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
  var valid_594270 = path.getOrDefault("matterId")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "matterId", valid_594270
  var valid_594271 = path.getOrDefault("holdId")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "holdId", valid_594271
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
  var valid_594272 = query.getOrDefault("upload_protocol")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "upload_protocol", valid_594272
  var valid_594273 = query.getOrDefault("fields")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "fields", valid_594273
  var valid_594274 = query.getOrDefault("quotaUser")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "quotaUser", valid_594274
  var valid_594275 = query.getOrDefault("alt")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = newJString("json"))
  if valid_594275 != nil:
    section.add "alt", valid_594275
  var valid_594276 = query.getOrDefault("oauth_token")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "oauth_token", valid_594276
  var valid_594277 = query.getOrDefault("callback")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "callback", valid_594277
  var valid_594278 = query.getOrDefault("access_token")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "access_token", valid_594278
  var valid_594279 = query.getOrDefault("uploadType")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "uploadType", valid_594279
  var valid_594280 = query.getOrDefault("key")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "key", valid_594280
  var valid_594281 = query.getOrDefault("$.xgafv")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = newJString("1"))
  if valid_594281 != nil:
    section.add "$.xgafv", valid_594281
  var valid_594282 = query.getOrDefault("prettyPrint")
  valid_594282 = validateParameter(valid_594282, JBool, required = false,
                                 default = newJBool(true))
  if valid_594282 != nil:
    section.add "prettyPrint", valid_594282
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

proc call*(call_594284: Call_VaultMattersHoldsAccountsCreate_594267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a HeldAccount to a hold. Accounts can only be added to a hold that
  ## has no held_org_unit set. Attempting to add an account to an OU-based
  ## hold will result in an error.
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_VaultMattersHoldsAccountsCreate_594267;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  var body_594288 = newJObject()
  add(query_594287, "upload_protocol", newJString(uploadProtocol))
  add(query_594287, "fields", newJString(fields))
  add(query_594287, "quotaUser", newJString(quotaUser))
  add(query_594287, "alt", newJString(alt))
  add(query_594287, "oauth_token", newJString(oauthToken))
  add(query_594287, "callback", newJString(callback))
  add(query_594287, "access_token", newJString(accessToken))
  add(query_594287, "uploadType", newJString(uploadType))
  add(path_594286, "matterId", newJString(matterId))
  add(query_594287, "key", newJString(key))
  add(query_594287, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594288 = body
  add(query_594287, "prettyPrint", newJBool(prettyPrint))
  add(path_594286, "holdId", newJString(holdId))
  result = call_594285.call(path_594286, query_594287, nil, nil, body_594288)

var vaultMattersHoldsAccountsCreate* = Call_VaultMattersHoldsAccountsCreate_594267(
    name: "vaultMattersHoldsAccountsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts",
    validator: validate_VaultMattersHoldsAccountsCreate_594268, base: "/",
    url: url_VaultMattersHoldsAccountsCreate_594269, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsList_594247 = ref object of OpenApiRestCall_593421
proc url_VaultMattersHoldsAccountsList_594249(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersHoldsAccountsList_594248(path: JsonNode; query: JsonNode;
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
  var valid_594250 = path.getOrDefault("matterId")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "matterId", valid_594250
  var valid_594251 = path.getOrDefault("holdId")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "holdId", valid_594251
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
  var valid_594252 = query.getOrDefault("upload_protocol")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "upload_protocol", valid_594252
  var valid_594253 = query.getOrDefault("fields")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "fields", valid_594253
  var valid_594254 = query.getOrDefault("quotaUser")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "quotaUser", valid_594254
  var valid_594255 = query.getOrDefault("alt")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = newJString("json"))
  if valid_594255 != nil:
    section.add "alt", valid_594255
  var valid_594256 = query.getOrDefault("oauth_token")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "oauth_token", valid_594256
  var valid_594257 = query.getOrDefault("callback")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "callback", valid_594257
  var valid_594258 = query.getOrDefault("access_token")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "access_token", valid_594258
  var valid_594259 = query.getOrDefault("uploadType")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "uploadType", valid_594259
  var valid_594260 = query.getOrDefault("key")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "key", valid_594260
  var valid_594261 = query.getOrDefault("$.xgafv")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = newJString("1"))
  if valid_594261 != nil:
    section.add "$.xgafv", valid_594261
  var valid_594262 = query.getOrDefault("prettyPrint")
  valid_594262 = validateParameter(valid_594262, JBool, required = false,
                                 default = newJBool(true))
  if valid_594262 != nil:
    section.add "prettyPrint", valid_594262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594263: Call_VaultMattersHoldsAccountsList_594247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists HeldAccounts for a hold. This will only list individually specified
  ## held accounts. If the hold is on an OU, then use
  ## <a href="https://developers.google.com/admin-sdk/">Admin SDK</a>
  ## to enumerate its members.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_VaultMattersHoldsAccountsList_594247;
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
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  add(query_594266, "upload_protocol", newJString(uploadProtocol))
  add(query_594266, "fields", newJString(fields))
  add(query_594266, "quotaUser", newJString(quotaUser))
  add(query_594266, "alt", newJString(alt))
  add(query_594266, "oauth_token", newJString(oauthToken))
  add(query_594266, "callback", newJString(callback))
  add(query_594266, "access_token", newJString(accessToken))
  add(query_594266, "uploadType", newJString(uploadType))
  add(path_594265, "matterId", newJString(matterId))
  add(query_594266, "key", newJString(key))
  add(query_594266, "$.xgafv", newJString(Xgafv))
  add(query_594266, "prettyPrint", newJBool(prettyPrint))
  add(path_594265, "holdId", newJString(holdId))
  result = call_594264.call(path_594265, query_594266, nil, nil, nil)

var vaultMattersHoldsAccountsList* = Call_VaultMattersHoldsAccountsList_594247(
    name: "vaultMattersHoldsAccountsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts",
    validator: validate_VaultMattersHoldsAccountsList_594248, base: "/",
    url: url_VaultMattersHoldsAccountsList_594249, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsDelete_594289 = ref object of OpenApiRestCall_593421
proc url_VaultMattersHoldsAccountsDelete_594291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersHoldsAccountsDelete_594290(path: JsonNode;
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
  var valid_594292 = path.getOrDefault("accountId")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "accountId", valid_594292
  var valid_594293 = path.getOrDefault("matterId")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "matterId", valid_594293
  var valid_594294 = path.getOrDefault("holdId")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "holdId", valid_594294
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
  var valid_594295 = query.getOrDefault("upload_protocol")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "upload_protocol", valid_594295
  var valid_594296 = query.getOrDefault("fields")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "fields", valid_594296
  var valid_594297 = query.getOrDefault("quotaUser")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "quotaUser", valid_594297
  var valid_594298 = query.getOrDefault("alt")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = newJString("json"))
  if valid_594298 != nil:
    section.add "alt", valid_594298
  var valid_594299 = query.getOrDefault("oauth_token")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "oauth_token", valid_594299
  var valid_594300 = query.getOrDefault("callback")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "callback", valid_594300
  var valid_594301 = query.getOrDefault("access_token")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "access_token", valid_594301
  var valid_594302 = query.getOrDefault("uploadType")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "uploadType", valid_594302
  var valid_594303 = query.getOrDefault("key")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "key", valid_594303
  var valid_594304 = query.getOrDefault("$.xgafv")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = newJString("1"))
  if valid_594304 != nil:
    section.add "$.xgafv", valid_594304
  var valid_594305 = query.getOrDefault("prettyPrint")
  valid_594305 = validateParameter(valid_594305, JBool, required = false,
                                 default = newJBool(true))
  if valid_594305 != nil:
    section.add "prettyPrint", valid_594305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594306: Call_VaultMattersHoldsAccountsDelete_594289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a HeldAccount from a hold. If this request leaves the hold with
  ## no held accounts, the hold will not apply to any accounts.
  ## 
  let valid = call_594306.validator(path, query, header, formData, body)
  let scheme = call_594306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594306.url(scheme.get, call_594306.host, call_594306.base,
                         call_594306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594306, url, valid)

proc call*(call_594307: Call_VaultMattersHoldsAccountsDelete_594289;
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
  var path_594308 = newJObject()
  var query_594309 = newJObject()
  add(query_594309, "upload_protocol", newJString(uploadProtocol))
  add(query_594309, "fields", newJString(fields))
  add(query_594309, "quotaUser", newJString(quotaUser))
  add(query_594309, "alt", newJString(alt))
  add(query_594309, "oauth_token", newJString(oauthToken))
  add(query_594309, "callback", newJString(callback))
  add(query_594309, "access_token", newJString(accessToken))
  add(query_594309, "uploadType", newJString(uploadType))
  add(path_594308, "accountId", newJString(accountId))
  add(path_594308, "matterId", newJString(matterId))
  add(query_594309, "key", newJString(key))
  add(query_594309, "$.xgafv", newJString(Xgafv))
  add(query_594309, "prettyPrint", newJBool(prettyPrint))
  add(path_594308, "holdId", newJString(holdId))
  result = call_594307.call(path_594308, query_594309, nil, nil, nil)

var vaultMattersHoldsAccountsDelete* = Call_VaultMattersHoldsAccountsDelete_594289(
    name: "vaultMattersHoldsAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts/{accountId}",
    validator: validate_VaultMattersHoldsAccountsDelete_594290, base: "/",
    url: url_VaultMattersHoldsAccountsDelete_594291, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAddHeldAccounts_594310 = ref object of OpenApiRestCall_593421
proc url_VaultMattersHoldsAddHeldAccounts_594312(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersHoldsAddHeldAccounts_594311(path: JsonNode;
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
  var valid_594313 = path.getOrDefault("matterId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "matterId", valid_594313
  var valid_594314 = path.getOrDefault("holdId")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "holdId", valid_594314
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
  var valid_594315 = query.getOrDefault("upload_protocol")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "upload_protocol", valid_594315
  var valid_594316 = query.getOrDefault("fields")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "fields", valid_594316
  var valid_594317 = query.getOrDefault("quotaUser")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "quotaUser", valid_594317
  var valid_594318 = query.getOrDefault("alt")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = newJString("json"))
  if valid_594318 != nil:
    section.add "alt", valid_594318
  var valid_594319 = query.getOrDefault("oauth_token")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "oauth_token", valid_594319
  var valid_594320 = query.getOrDefault("callback")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "callback", valid_594320
  var valid_594321 = query.getOrDefault("access_token")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "access_token", valid_594321
  var valid_594322 = query.getOrDefault("uploadType")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "uploadType", valid_594322
  var valid_594323 = query.getOrDefault("key")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "key", valid_594323
  var valid_594324 = query.getOrDefault("$.xgafv")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = newJString("1"))
  if valid_594324 != nil:
    section.add "$.xgafv", valid_594324
  var valid_594325 = query.getOrDefault("prettyPrint")
  valid_594325 = validateParameter(valid_594325, JBool, required = false,
                                 default = newJBool(true))
  if valid_594325 != nil:
    section.add "prettyPrint", valid_594325
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

proc call*(call_594327: Call_VaultMattersHoldsAddHeldAccounts_594310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds HeldAccounts to a hold. Returns a list of accounts that have been
  ## successfully added. Accounts can only be added to an existing account-based
  ## hold.
  ## 
  let valid = call_594327.validator(path, query, header, formData, body)
  let scheme = call_594327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594327.url(scheme.get, call_594327.host, call_594327.base,
                         call_594327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594327, url, valid)

proc call*(call_594328: Call_VaultMattersHoldsAddHeldAccounts_594310;
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
  var path_594329 = newJObject()
  var query_594330 = newJObject()
  var body_594331 = newJObject()
  add(query_594330, "upload_protocol", newJString(uploadProtocol))
  add(query_594330, "fields", newJString(fields))
  add(query_594330, "quotaUser", newJString(quotaUser))
  add(query_594330, "alt", newJString(alt))
  add(query_594330, "oauth_token", newJString(oauthToken))
  add(query_594330, "callback", newJString(callback))
  add(query_594330, "access_token", newJString(accessToken))
  add(query_594330, "uploadType", newJString(uploadType))
  add(path_594329, "matterId", newJString(matterId))
  add(query_594330, "key", newJString(key))
  add(query_594330, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594331 = body
  add(query_594330, "prettyPrint", newJBool(prettyPrint))
  add(path_594329, "holdId", newJString(holdId))
  result = call_594328.call(path_594329, query_594330, nil, nil, body_594331)

var vaultMattersHoldsAddHeldAccounts* = Call_VaultMattersHoldsAddHeldAccounts_594310(
    name: "vaultMattersHoldsAddHeldAccounts", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}:addHeldAccounts",
    validator: validate_VaultMattersHoldsAddHeldAccounts_594311, base: "/",
    url: url_VaultMattersHoldsAddHeldAccounts_594312, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsRemoveHeldAccounts_594332 = ref object of OpenApiRestCall_593421
proc url_VaultMattersHoldsRemoveHeldAccounts_594334(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersHoldsRemoveHeldAccounts_594333(path: JsonNode;
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
  var valid_594335 = path.getOrDefault("matterId")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "matterId", valid_594335
  var valid_594336 = path.getOrDefault("holdId")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "holdId", valid_594336
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
  var valid_594337 = query.getOrDefault("upload_protocol")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "upload_protocol", valid_594337
  var valid_594338 = query.getOrDefault("fields")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "fields", valid_594338
  var valid_594339 = query.getOrDefault("quotaUser")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "quotaUser", valid_594339
  var valid_594340 = query.getOrDefault("alt")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = newJString("json"))
  if valid_594340 != nil:
    section.add "alt", valid_594340
  var valid_594341 = query.getOrDefault("oauth_token")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "oauth_token", valid_594341
  var valid_594342 = query.getOrDefault("callback")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "callback", valid_594342
  var valid_594343 = query.getOrDefault("access_token")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "access_token", valid_594343
  var valid_594344 = query.getOrDefault("uploadType")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "uploadType", valid_594344
  var valid_594345 = query.getOrDefault("key")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "key", valid_594345
  var valid_594346 = query.getOrDefault("$.xgafv")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = newJString("1"))
  if valid_594346 != nil:
    section.add "$.xgafv", valid_594346
  var valid_594347 = query.getOrDefault("prettyPrint")
  valid_594347 = validateParameter(valid_594347, JBool, required = false,
                                 default = newJBool(true))
  if valid_594347 != nil:
    section.add "prettyPrint", valid_594347
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

proc call*(call_594349: Call_VaultMattersHoldsRemoveHeldAccounts_594332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes HeldAccounts from a hold. Returns a list of statuses in the same
  ## order as the request. If this request leaves the hold with no held
  ## accounts, the hold will not apply to any accounts.
  ## 
  let valid = call_594349.validator(path, query, header, formData, body)
  let scheme = call_594349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594349.url(scheme.get, call_594349.host, call_594349.base,
                         call_594349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594349, url, valid)

proc call*(call_594350: Call_VaultMattersHoldsRemoveHeldAccounts_594332;
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
  var path_594351 = newJObject()
  var query_594352 = newJObject()
  var body_594353 = newJObject()
  add(query_594352, "upload_protocol", newJString(uploadProtocol))
  add(query_594352, "fields", newJString(fields))
  add(query_594352, "quotaUser", newJString(quotaUser))
  add(query_594352, "alt", newJString(alt))
  add(query_594352, "oauth_token", newJString(oauthToken))
  add(query_594352, "callback", newJString(callback))
  add(query_594352, "access_token", newJString(accessToken))
  add(query_594352, "uploadType", newJString(uploadType))
  add(path_594351, "matterId", newJString(matterId))
  add(query_594352, "key", newJString(key))
  add(query_594352, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594353 = body
  add(query_594352, "prettyPrint", newJBool(prettyPrint))
  add(path_594351, "holdId", newJString(holdId))
  result = call_594350.call(path_594351, query_594352, nil, nil, body_594353)

var vaultMattersHoldsRemoveHeldAccounts* = Call_VaultMattersHoldsRemoveHeldAccounts_594332(
    name: "vaultMattersHoldsRemoveHeldAccounts", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}:removeHeldAccounts",
    validator: validate_VaultMattersHoldsRemoveHeldAccounts_594333, base: "/",
    url: url_VaultMattersHoldsRemoveHeldAccounts_594334, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesCreate_594375 = ref object of OpenApiRestCall_593421
proc url_VaultMattersSavedQueriesCreate_594377(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersSavedQueriesCreate_594376(path: JsonNode;
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
  var valid_594378 = path.getOrDefault("matterId")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "matterId", valid_594378
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
  var valid_594379 = query.getOrDefault("upload_protocol")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "upload_protocol", valid_594379
  var valid_594380 = query.getOrDefault("fields")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "fields", valid_594380
  var valid_594381 = query.getOrDefault("quotaUser")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "quotaUser", valid_594381
  var valid_594382 = query.getOrDefault("alt")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = newJString("json"))
  if valid_594382 != nil:
    section.add "alt", valid_594382
  var valid_594383 = query.getOrDefault("oauth_token")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "oauth_token", valid_594383
  var valid_594384 = query.getOrDefault("callback")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "callback", valid_594384
  var valid_594385 = query.getOrDefault("access_token")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "access_token", valid_594385
  var valid_594386 = query.getOrDefault("uploadType")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = nil)
  if valid_594386 != nil:
    section.add "uploadType", valid_594386
  var valid_594387 = query.getOrDefault("key")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = nil)
  if valid_594387 != nil:
    section.add "key", valid_594387
  var valid_594388 = query.getOrDefault("$.xgafv")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = newJString("1"))
  if valid_594388 != nil:
    section.add "$.xgafv", valid_594388
  var valid_594389 = query.getOrDefault("prettyPrint")
  valid_594389 = validateParameter(valid_594389, JBool, required = false,
                                 default = newJBool(true))
  if valid_594389 != nil:
    section.add "prettyPrint", valid_594389
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

proc call*(call_594391: Call_VaultMattersSavedQueriesCreate_594375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a saved query.
  ## 
  let valid = call_594391.validator(path, query, header, formData, body)
  let scheme = call_594391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594391.url(scheme.get, call_594391.host, call_594391.base,
                         call_594391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594391, url, valid)

proc call*(call_594392: Call_VaultMattersSavedQueriesCreate_594375;
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
  var path_594393 = newJObject()
  var query_594394 = newJObject()
  var body_594395 = newJObject()
  add(query_594394, "upload_protocol", newJString(uploadProtocol))
  add(query_594394, "fields", newJString(fields))
  add(query_594394, "quotaUser", newJString(quotaUser))
  add(query_594394, "alt", newJString(alt))
  add(query_594394, "oauth_token", newJString(oauthToken))
  add(query_594394, "callback", newJString(callback))
  add(query_594394, "access_token", newJString(accessToken))
  add(query_594394, "uploadType", newJString(uploadType))
  add(path_594393, "matterId", newJString(matterId))
  add(query_594394, "key", newJString(key))
  add(query_594394, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594395 = body
  add(query_594394, "prettyPrint", newJBool(prettyPrint))
  result = call_594392.call(path_594393, query_594394, nil, nil, body_594395)

var vaultMattersSavedQueriesCreate* = Call_VaultMattersSavedQueriesCreate_594375(
    name: "vaultMattersSavedQueriesCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/savedQueries",
    validator: validate_VaultMattersSavedQueriesCreate_594376, base: "/",
    url: url_VaultMattersSavedQueriesCreate_594377, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesList_594354 = ref object of OpenApiRestCall_593421
proc url_VaultMattersSavedQueriesList_594356(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersSavedQueriesList_594355(path: JsonNode; query: JsonNode;
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
  var valid_594357 = path.getOrDefault("matterId")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "matterId", valid_594357
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
  var valid_594358 = query.getOrDefault("upload_protocol")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "upload_protocol", valid_594358
  var valid_594359 = query.getOrDefault("fields")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "fields", valid_594359
  var valid_594360 = query.getOrDefault("pageToken")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "pageToken", valid_594360
  var valid_594361 = query.getOrDefault("quotaUser")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "quotaUser", valid_594361
  var valid_594362 = query.getOrDefault("alt")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = newJString("json"))
  if valid_594362 != nil:
    section.add "alt", valid_594362
  var valid_594363 = query.getOrDefault("oauth_token")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "oauth_token", valid_594363
  var valid_594364 = query.getOrDefault("callback")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "callback", valid_594364
  var valid_594365 = query.getOrDefault("access_token")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "access_token", valid_594365
  var valid_594366 = query.getOrDefault("uploadType")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "uploadType", valid_594366
  var valid_594367 = query.getOrDefault("key")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "key", valid_594367
  var valid_594368 = query.getOrDefault("$.xgafv")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = newJString("1"))
  if valid_594368 != nil:
    section.add "$.xgafv", valid_594368
  var valid_594369 = query.getOrDefault("pageSize")
  valid_594369 = validateParameter(valid_594369, JInt, required = false, default = nil)
  if valid_594369 != nil:
    section.add "pageSize", valid_594369
  var valid_594370 = query.getOrDefault("prettyPrint")
  valid_594370 = validateParameter(valid_594370, JBool, required = false,
                                 default = newJBool(true))
  if valid_594370 != nil:
    section.add "prettyPrint", valid_594370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594371: Call_VaultMattersSavedQueriesList_594354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists saved queries within a matter. An empty page token in
  ## ListSavedQueriesResponse denotes no more saved queries to list.
  ## 
  let valid = call_594371.validator(path, query, header, formData, body)
  let scheme = call_594371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594371.url(scheme.get, call_594371.host, call_594371.base,
                         call_594371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594371, url, valid)

proc call*(call_594372: Call_VaultMattersSavedQueriesList_594354; matterId: string;
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
  var path_594373 = newJObject()
  var query_594374 = newJObject()
  add(query_594374, "upload_protocol", newJString(uploadProtocol))
  add(query_594374, "fields", newJString(fields))
  add(query_594374, "pageToken", newJString(pageToken))
  add(query_594374, "quotaUser", newJString(quotaUser))
  add(query_594374, "alt", newJString(alt))
  add(query_594374, "oauth_token", newJString(oauthToken))
  add(query_594374, "callback", newJString(callback))
  add(query_594374, "access_token", newJString(accessToken))
  add(query_594374, "uploadType", newJString(uploadType))
  add(path_594373, "matterId", newJString(matterId))
  add(query_594374, "key", newJString(key))
  add(query_594374, "$.xgafv", newJString(Xgafv))
  add(query_594374, "pageSize", newJInt(pageSize))
  add(query_594374, "prettyPrint", newJBool(prettyPrint))
  result = call_594372.call(path_594373, query_594374, nil, nil, nil)

var vaultMattersSavedQueriesList* = Call_VaultMattersSavedQueriesList_594354(
    name: "vaultMattersSavedQueriesList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/savedQueries",
    validator: validate_VaultMattersSavedQueriesList_594355, base: "/",
    url: url_VaultMattersSavedQueriesList_594356, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesGet_594396 = ref object of OpenApiRestCall_593421
proc url_VaultMattersSavedQueriesGet_594398(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersSavedQueriesGet_594397(path: JsonNode; query: JsonNode;
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
  var valid_594399 = path.getOrDefault("matterId")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "matterId", valid_594399
  var valid_594400 = path.getOrDefault("savedQueryId")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "savedQueryId", valid_594400
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
  var valid_594401 = query.getOrDefault("upload_protocol")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "upload_protocol", valid_594401
  var valid_594402 = query.getOrDefault("fields")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "fields", valid_594402
  var valid_594403 = query.getOrDefault("quotaUser")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "quotaUser", valid_594403
  var valid_594404 = query.getOrDefault("alt")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = newJString("json"))
  if valid_594404 != nil:
    section.add "alt", valid_594404
  var valid_594405 = query.getOrDefault("oauth_token")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = nil)
  if valid_594405 != nil:
    section.add "oauth_token", valid_594405
  var valid_594406 = query.getOrDefault("callback")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "callback", valid_594406
  var valid_594407 = query.getOrDefault("access_token")
  valid_594407 = validateParameter(valid_594407, JString, required = false,
                                 default = nil)
  if valid_594407 != nil:
    section.add "access_token", valid_594407
  var valid_594408 = query.getOrDefault("uploadType")
  valid_594408 = validateParameter(valid_594408, JString, required = false,
                                 default = nil)
  if valid_594408 != nil:
    section.add "uploadType", valid_594408
  var valid_594409 = query.getOrDefault("key")
  valid_594409 = validateParameter(valid_594409, JString, required = false,
                                 default = nil)
  if valid_594409 != nil:
    section.add "key", valid_594409
  var valid_594410 = query.getOrDefault("$.xgafv")
  valid_594410 = validateParameter(valid_594410, JString, required = false,
                                 default = newJString("1"))
  if valid_594410 != nil:
    section.add "$.xgafv", valid_594410
  var valid_594411 = query.getOrDefault("prettyPrint")
  valid_594411 = validateParameter(valid_594411, JBool, required = false,
                                 default = newJBool(true))
  if valid_594411 != nil:
    section.add "prettyPrint", valid_594411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594412: Call_VaultMattersSavedQueriesGet_594396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a saved query by Id.
  ## 
  let valid = call_594412.validator(path, query, header, formData, body)
  let scheme = call_594412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594412.url(scheme.get, call_594412.host, call_594412.base,
                         call_594412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594412, url, valid)

proc call*(call_594413: Call_VaultMattersSavedQueriesGet_594396; matterId: string;
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
  var path_594414 = newJObject()
  var query_594415 = newJObject()
  add(query_594415, "upload_protocol", newJString(uploadProtocol))
  add(query_594415, "fields", newJString(fields))
  add(query_594415, "quotaUser", newJString(quotaUser))
  add(query_594415, "alt", newJString(alt))
  add(query_594415, "oauth_token", newJString(oauthToken))
  add(query_594415, "callback", newJString(callback))
  add(query_594415, "access_token", newJString(accessToken))
  add(query_594415, "uploadType", newJString(uploadType))
  add(path_594414, "matterId", newJString(matterId))
  add(query_594415, "key", newJString(key))
  add(query_594415, "$.xgafv", newJString(Xgafv))
  add(query_594415, "prettyPrint", newJBool(prettyPrint))
  add(path_594414, "savedQueryId", newJString(savedQueryId))
  result = call_594413.call(path_594414, query_594415, nil, nil, nil)

var vaultMattersSavedQueriesGet* = Call_VaultMattersSavedQueriesGet_594396(
    name: "vaultMattersSavedQueriesGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/savedQueries/{savedQueryId}",
    validator: validate_VaultMattersSavedQueriesGet_594397, base: "/",
    url: url_VaultMattersSavedQueriesGet_594398, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesDelete_594416 = ref object of OpenApiRestCall_593421
proc url_VaultMattersSavedQueriesDelete_594418(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersSavedQueriesDelete_594417(path: JsonNode;
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
  var valid_594419 = path.getOrDefault("matterId")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "matterId", valid_594419
  var valid_594420 = path.getOrDefault("savedQueryId")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "savedQueryId", valid_594420
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
  var valid_594421 = query.getOrDefault("upload_protocol")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "upload_protocol", valid_594421
  var valid_594422 = query.getOrDefault("fields")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "fields", valid_594422
  var valid_594423 = query.getOrDefault("quotaUser")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "quotaUser", valid_594423
  var valid_594424 = query.getOrDefault("alt")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = newJString("json"))
  if valid_594424 != nil:
    section.add "alt", valid_594424
  var valid_594425 = query.getOrDefault("oauth_token")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "oauth_token", valid_594425
  var valid_594426 = query.getOrDefault("callback")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = nil)
  if valid_594426 != nil:
    section.add "callback", valid_594426
  var valid_594427 = query.getOrDefault("access_token")
  valid_594427 = validateParameter(valid_594427, JString, required = false,
                                 default = nil)
  if valid_594427 != nil:
    section.add "access_token", valid_594427
  var valid_594428 = query.getOrDefault("uploadType")
  valid_594428 = validateParameter(valid_594428, JString, required = false,
                                 default = nil)
  if valid_594428 != nil:
    section.add "uploadType", valid_594428
  var valid_594429 = query.getOrDefault("key")
  valid_594429 = validateParameter(valid_594429, JString, required = false,
                                 default = nil)
  if valid_594429 != nil:
    section.add "key", valid_594429
  var valid_594430 = query.getOrDefault("$.xgafv")
  valid_594430 = validateParameter(valid_594430, JString, required = false,
                                 default = newJString("1"))
  if valid_594430 != nil:
    section.add "$.xgafv", valid_594430
  var valid_594431 = query.getOrDefault("prettyPrint")
  valid_594431 = validateParameter(valid_594431, JBool, required = false,
                                 default = newJBool(true))
  if valid_594431 != nil:
    section.add "prettyPrint", valid_594431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594432: Call_VaultMattersSavedQueriesDelete_594416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a saved query by Id.
  ## 
  let valid = call_594432.validator(path, query, header, formData, body)
  let scheme = call_594432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594432.url(scheme.get, call_594432.host, call_594432.base,
                         call_594432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594432, url, valid)

proc call*(call_594433: Call_VaultMattersSavedQueriesDelete_594416;
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
  var path_594434 = newJObject()
  var query_594435 = newJObject()
  add(query_594435, "upload_protocol", newJString(uploadProtocol))
  add(query_594435, "fields", newJString(fields))
  add(query_594435, "quotaUser", newJString(quotaUser))
  add(query_594435, "alt", newJString(alt))
  add(query_594435, "oauth_token", newJString(oauthToken))
  add(query_594435, "callback", newJString(callback))
  add(query_594435, "access_token", newJString(accessToken))
  add(query_594435, "uploadType", newJString(uploadType))
  add(path_594434, "matterId", newJString(matterId))
  add(query_594435, "key", newJString(key))
  add(query_594435, "$.xgafv", newJString(Xgafv))
  add(query_594435, "prettyPrint", newJBool(prettyPrint))
  add(path_594434, "savedQueryId", newJString(savedQueryId))
  result = call_594433.call(path_594434, query_594435, nil, nil, nil)

var vaultMattersSavedQueriesDelete* = Call_VaultMattersSavedQueriesDelete_594416(
    name: "vaultMattersSavedQueriesDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/savedQueries/{savedQueryId}",
    validator: validate_VaultMattersSavedQueriesDelete_594417, base: "/",
    url: url_VaultMattersSavedQueriesDelete_594418, schemes: {Scheme.Https})
type
  Call_VaultMattersAddPermissions_594436 = ref object of OpenApiRestCall_593421
proc url_VaultMattersAddPermissions_594438(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersAddPermissions_594437(path: JsonNode; query: JsonNode;
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
  var valid_594439 = path.getOrDefault("matterId")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "matterId", valid_594439
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
  var valid_594440 = query.getOrDefault("upload_protocol")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "upload_protocol", valid_594440
  var valid_594441 = query.getOrDefault("fields")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = nil)
  if valid_594441 != nil:
    section.add "fields", valid_594441
  var valid_594442 = query.getOrDefault("quotaUser")
  valid_594442 = validateParameter(valid_594442, JString, required = false,
                                 default = nil)
  if valid_594442 != nil:
    section.add "quotaUser", valid_594442
  var valid_594443 = query.getOrDefault("alt")
  valid_594443 = validateParameter(valid_594443, JString, required = false,
                                 default = newJString("json"))
  if valid_594443 != nil:
    section.add "alt", valid_594443
  var valid_594444 = query.getOrDefault("oauth_token")
  valid_594444 = validateParameter(valid_594444, JString, required = false,
                                 default = nil)
  if valid_594444 != nil:
    section.add "oauth_token", valid_594444
  var valid_594445 = query.getOrDefault("callback")
  valid_594445 = validateParameter(valid_594445, JString, required = false,
                                 default = nil)
  if valid_594445 != nil:
    section.add "callback", valid_594445
  var valid_594446 = query.getOrDefault("access_token")
  valid_594446 = validateParameter(valid_594446, JString, required = false,
                                 default = nil)
  if valid_594446 != nil:
    section.add "access_token", valid_594446
  var valid_594447 = query.getOrDefault("uploadType")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = nil)
  if valid_594447 != nil:
    section.add "uploadType", valid_594447
  var valid_594448 = query.getOrDefault("key")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = nil)
  if valid_594448 != nil:
    section.add "key", valid_594448
  var valid_594449 = query.getOrDefault("$.xgafv")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = newJString("1"))
  if valid_594449 != nil:
    section.add "$.xgafv", valid_594449
  var valid_594450 = query.getOrDefault("prettyPrint")
  valid_594450 = validateParameter(valid_594450, JBool, required = false,
                                 default = newJBool(true))
  if valid_594450 != nil:
    section.add "prettyPrint", valid_594450
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

proc call*(call_594452: Call_VaultMattersAddPermissions_594436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an account as a matter collaborator.
  ## 
  let valid = call_594452.validator(path, query, header, formData, body)
  let scheme = call_594452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594452.url(scheme.get, call_594452.host, call_594452.base,
                         call_594452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594452, url, valid)

proc call*(call_594453: Call_VaultMattersAddPermissions_594436; matterId: string;
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
  var path_594454 = newJObject()
  var query_594455 = newJObject()
  var body_594456 = newJObject()
  add(query_594455, "upload_protocol", newJString(uploadProtocol))
  add(query_594455, "fields", newJString(fields))
  add(query_594455, "quotaUser", newJString(quotaUser))
  add(query_594455, "alt", newJString(alt))
  add(query_594455, "oauth_token", newJString(oauthToken))
  add(query_594455, "callback", newJString(callback))
  add(query_594455, "access_token", newJString(accessToken))
  add(query_594455, "uploadType", newJString(uploadType))
  add(path_594454, "matterId", newJString(matterId))
  add(query_594455, "key", newJString(key))
  add(query_594455, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594456 = body
  add(query_594455, "prettyPrint", newJBool(prettyPrint))
  result = call_594453.call(path_594454, query_594455, nil, nil, body_594456)

var vaultMattersAddPermissions* = Call_VaultMattersAddPermissions_594436(
    name: "vaultMattersAddPermissions", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:addPermissions",
    validator: validate_VaultMattersAddPermissions_594437, base: "/",
    url: url_VaultMattersAddPermissions_594438, schemes: {Scheme.Https})
type
  Call_VaultMattersClose_594457 = ref object of OpenApiRestCall_593421
proc url_VaultMattersClose_594459(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersClose_594458(path: JsonNode; query: JsonNode;
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
  var valid_594460 = path.getOrDefault("matterId")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "matterId", valid_594460
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
  var valid_594461 = query.getOrDefault("upload_protocol")
  valid_594461 = validateParameter(valid_594461, JString, required = false,
                                 default = nil)
  if valid_594461 != nil:
    section.add "upload_protocol", valid_594461
  var valid_594462 = query.getOrDefault("fields")
  valid_594462 = validateParameter(valid_594462, JString, required = false,
                                 default = nil)
  if valid_594462 != nil:
    section.add "fields", valid_594462
  var valid_594463 = query.getOrDefault("quotaUser")
  valid_594463 = validateParameter(valid_594463, JString, required = false,
                                 default = nil)
  if valid_594463 != nil:
    section.add "quotaUser", valid_594463
  var valid_594464 = query.getOrDefault("alt")
  valid_594464 = validateParameter(valid_594464, JString, required = false,
                                 default = newJString("json"))
  if valid_594464 != nil:
    section.add "alt", valid_594464
  var valid_594465 = query.getOrDefault("oauth_token")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "oauth_token", valid_594465
  var valid_594466 = query.getOrDefault("callback")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = nil)
  if valid_594466 != nil:
    section.add "callback", valid_594466
  var valid_594467 = query.getOrDefault("access_token")
  valid_594467 = validateParameter(valid_594467, JString, required = false,
                                 default = nil)
  if valid_594467 != nil:
    section.add "access_token", valid_594467
  var valid_594468 = query.getOrDefault("uploadType")
  valid_594468 = validateParameter(valid_594468, JString, required = false,
                                 default = nil)
  if valid_594468 != nil:
    section.add "uploadType", valid_594468
  var valid_594469 = query.getOrDefault("key")
  valid_594469 = validateParameter(valid_594469, JString, required = false,
                                 default = nil)
  if valid_594469 != nil:
    section.add "key", valid_594469
  var valid_594470 = query.getOrDefault("$.xgafv")
  valid_594470 = validateParameter(valid_594470, JString, required = false,
                                 default = newJString("1"))
  if valid_594470 != nil:
    section.add "$.xgafv", valid_594470
  var valid_594471 = query.getOrDefault("prettyPrint")
  valid_594471 = validateParameter(valid_594471, JBool, required = false,
                                 default = newJBool(true))
  if valid_594471 != nil:
    section.add "prettyPrint", valid_594471
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

proc call*(call_594473: Call_VaultMattersClose_594457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Closes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_594473.validator(path, query, header, formData, body)
  let scheme = call_594473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594473.url(scheme.get, call_594473.host, call_594473.base,
                         call_594473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594473, url, valid)

proc call*(call_594474: Call_VaultMattersClose_594457; matterId: string;
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
  var path_594475 = newJObject()
  var query_594476 = newJObject()
  var body_594477 = newJObject()
  add(query_594476, "upload_protocol", newJString(uploadProtocol))
  add(query_594476, "fields", newJString(fields))
  add(query_594476, "quotaUser", newJString(quotaUser))
  add(query_594476, "alt", newJString(alt))
  add(query_594476, "oauth_token", newJString(oauthToken))
  add(query_594476, "callback", newJString(callback))
  add(query_594476, "access_token", newJString(accessToken))
  add(query_594476, "uploadType", newJString(uploadType))
  add(path_594475, "matterId", newJString(matterId))
  add(query_594476, "key", newJString(key))
  add(query_594476, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594477 = body
  add(query_594476, "prettyPrint", newJBool(prettyPrint))
  result = call_594474.call(path_594475, query_594476, nil, nil, body_594477)

var vaultMattersClose* = Call_VaultMattersClose_594457(name: "vaultMattersClose",
    meth: HttpMethod.HttpPost, host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}:close", validator: validate_VaultMattersClose_594458,
    base: "/", url: url_VaultMattersClose_594459, schemes: {Scheme.Https})
type
  Call_VaultMattersRemovePermissions_594478 = ref object of OpenApiRestCall_593421
proc url_VaultMattersRemovePermissions_594480(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersRemovePermissions_594479(path: JsonNode; query: JsonNode;
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
  var valid_594481 = path.getOrDefault("matterId")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "matterId", valid_594481
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
  var valid_594482 = query.getOrDefault("upload_protocol")
  valid_594482 = validateParameter(valid_594482, JString, required = false,
                                 default = nil)
  if valid_594482 != nil:
    section.add "upload_protocol", valid_594482
  var valid_594483 = query.getOrDefault("fields")
  valid_594483 = validateParameter(valid_594483, JString, required = false,
                                 default = nil)
  if valid_594483 != nil:
    section.add "fields", valid_594483
  var valid_594484 = query.getOrDefault("quotaUser")
  valid_594484 = validateParameter(valid_594484, JString, required = false,
                                 default = nil)
  if valid_594484 != nil:
    section.add "quotaUser", valid_594484
  var valid_594485 = query.getOrDefault("alt")
  valid_594485 = validateParameter(valid_594485, JString, required = false,
                                 default = newJString("json"))
  if valid_594485 != nil:
    section.add "alt", valid_594485
  var valid_594486 = query.getOrDefault("oauth_token")
  valid_594486 = validateParameter(valid_594486, JString, required = false,
                                 default = nil)
  if valid_594486 != nil:
    section.add "oauth_token", valid_594486
  var valid_594487 = query.getOrDefault("callback")
  valid_594487 = validateParameter(valid_594487, JString, required = false,
                                 default = nil)
  if valid_594487 != nil:
    section.add "callback", valid_594487
  var valid_594488 = query.getOrDefault("access_token")
  valid_594488 = validateParameter(valid_594488, JString, required = false,
                                 default = nil)
  if valid_594488 != nil:
    section.add "access_token", valid_594488
  var valid_594489 = query.getOrDefault("uploadType")
  valid_594489 = validateParameter(valid_594489, JString, required = false,
                                 default = nil)
  if valid_594489 != nil:
    section.add "uploadType", valid_594489
  var valid_594490 = query.getOrDefault("key")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "key", valid_594490
  var valid_594491 = query.getOrDefault("$.xgafv")
  valid_594491 = validateParameter(valid_594491, JString, required = false,
                                 default = newJString("1"))
  if valid_594491 != nil:
    section.add "$.xgafv", valid_594491
  var valid_594492 = query.getOrDefault("prettyPrint")
  valid_594492 = validateParameter(valid_594492, JBool, required = false,
                                 default = newJBool(true))
  if valid_594492 != nil:
    section.add "prettyPrint", valid_594492
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

proc call*(call_594494: Call_VaultMattersRemovePermissions_594478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an account as a matter collaborator.
  ## 
  let valid = call_594494.validator(path, query, header, formData, body)
  let scheme = call_594494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594494.url(scheme.get, call_594494.host, call_594494.base,
                         call_594494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594494, url, valid)

proc call*(call_594495: Call_VaultMattersRemovePermissions_594478;
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
  var path_594496 = newJObject()
  var query_594497 = newJObject()
  var body_594498 = newJObject()
  add(query_594497, "upload_protocol", newJString(uploadProtocol))
  add(query_594497, "fields", newJString(fields))
  add(query_594497, "quotaUser", newJString(quotaUser))
  add(query_594497, "alt", newJString(alt))
  add(query_594497, "oauth_token", newJString(oauthToken))
  add(query_594497, "callback", newJString(callback))
  add(query_594497, "access_token", newJString(accessToken))
  add(query_594497, "uploadType", newJString(uploadType))
  add(path_594496, "matterId", newJString(matterId))
  add(query_594497, "key", newJString(key))
  add(query_594497, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594498 = body
  add(query_594497, "prettyPrint", newJBool(prettyPrint))
  result = call_594495.call(path_594496, query_594497, nil, nil, body_594498)

var vaultMattersRemovePermissions* = Call_VaultMattersRemovePermissions_594478(
    name: "vaultMattersRemovePermissions", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}:removePermissions",
    validator: validate_VaultMattersRemovePermissions_594479, base: "/",
    url: url_VaultMattersRemovePermissions_594480, schemes: {Scheme.Https})
type
  Call_VaultMattersReopen_594499 = ref object of OpenApiRestCall_593421
proc url_VaultMattersReopen_594501(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersReopen_594500(path: JsonNode; query: JsonNode;
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
  var valid_594502 = path.getOrDefault("matterId")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "matterId", valid_594502
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
  var valid_594503 = query.getOrDefault("upload_protocol")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = nil)
  if valid_594503 != nil:
    section.add "upload_protocol", valid_594503
  var valid_594504 = query.getOrDefault("fields")
  valid_594504 = validateParameter(valid_594504, JString, required = false,
                                 default = nil)
  if valid_594504 != nil:
    section.add "fields", valid_594504
  var valid_594505 = query.getOrDefault("quotaUser")
  valid_594505 = validateParameter(valid_594505, JString, required = false,
                                 default = nil)
  if valid_594505 != nil:
    section.add "quotaUser", valid_594505
  var valid_594506 = query.getOrDefault("alt")
  valid_594506 = validateParameter(valid_594506, JString, required = false,
                                 default = newJString("json"))
  if valid_594506 != nil:
    section.add "alt", valid_594506
  var valid_594507 = query.getOrDefault("oauth_token")
  valid_594507 = validateParameter(valid_594507, JString, required = false,
                                 default = nil)
  if valid_594507 != nil:
    section.add "oauth_token", valid_594507
  var valid_594508 = query.getOrDefault("callback")
  valid_594508 = validateParameter(valid_594508, JString, required = false,
                                 default = nil)
  if valid_594508 != nil:
    section.add "callback", valid_594508
  var valid_594509 = query.getOrDefault("access_token")
  valid_594509 = validateParameter(valid_594509, JString, required = false,
                                 default = nil)
  if valid_594509 != nil:
    section.add "access_token", valid_594509
  var valid_594510 = query.getOrDefault("uploadType")
  valid_594510 = validateParameter(valid_594510, JString, required = false,
                                 default = nil)
  if valid_594510 != nil:
    section.add "uploadType", valid_594510
  var valid_594511 = query.getOrDefault("key")
  valid_594511 = validateParameter(valid_594511, JString, required = false,
                                 default = nil)
  if valid_594511 != nil:
    section.add "key", valid_594511
  var valid_594512 = query.getOrDefault("$.xgafv")
  valid_594512 = validateParameter(valid_594512, JString, required = false,
                                 default = newJString("1"))
  if valid_594512 != nil:
    section.add "$.xgafv", valid_594512
  var valid_594513 = query.getOrDefault("prettyPrint")
  valid_594513 = validateParameter(valid_594513, JBool, required = false,
                                 default = newJBool(true))
  if valid_594513 != nil:
    section.add "prettyPrint", valid_594513
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

proc call*(call_594515: Call_VaultMattersReopen_594499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reopens the specified matter. Returns matter with updated state.
  ## 
  let valid = call_594515.validator(path, query, header, formData, body)
  let scheme = call_594515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594515.url(scheme.get, call_594515.host, call_594515.base,
                         call_594515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594515, url, valid)

proc call*(call_594516: Call_VaultMattersReopen_594499; matterId: string;
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
  var path_594517 = newJObject()
  var query_594518 = newJObject()
  var body_594519 = newJObject()
  add(query_594518, "upload_protocol", newJString(uploadProtocol))
  add(query_594518, "fields", newJString(fields))
  add(query_594518, "quotaUser", newJString(quotaUser))
  add(query_594518, "alt", newJString(alt))
  add(query_594518, "oauth_token", newJString(oauthToken))
  add(query_594518, "callback", newJString(callback))
  add(query_594518, "access_token", newJString(accessToken))
  add(query_594518, "uploadType", newJString(uploadType))
  add(path_594517, "matterId", newJString(matterId))
  add(query_594518, "key", newJString(key))
  add(query_594518, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594519 = body
  add(query_594518, "prettyPrint", newJBool(prettyPrint))
  result = call_594516.call(path_594517, query_594518, nil, nil, body_594519)

var vaultMattersReopen* = Call_VaultMattersReopen_594499(
    name: "vaultMattersReopen", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:reopen",
    validator: validate_VaultMattersReopen_594500, base: "/",
    url: url_VaultMattersReopen_594501, schemes: {Scheme.Https})
type
  Call_VaultMattersUndelete_594520 = ref object of OpenApiRestCall_593421
proc url_VaultMattersUndelete_594522(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VaultMattersUndelete_594521(path: JsonNode; query: JsonNode;
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
  var valid_594523 = path.getOrDefault("matterId")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "matterId", valid_594523
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
  var valid_594524 = query.getOrDefault("upload_protocol")
  valid_594524 = validateParameter(valid_594524, JString, required = false,
                                 default = nil)
  if valid_594524 != nil:
    section.add "upload_protocol", valid_594524
  var valid_594525 = query.getOrDefault("fields")
  valid_594525 = validateParameter(valid_594525, JString, required = false,
                                 default = nil)
  if valid_594525 != nil:
    section.add "fields", valid_594525
  var valid_594526 = query.getOrDefault("quotaUser")
  valid_594526 = validateParameter(valid_594526, JString, required = false,
                                 default = nil)
  if valid_594526 != nil:
    section.add "quotaUser", valid_594526
  var valid_594527 = query.getOrDefault("alt")
  valid_594527 = validateParameter(valid_594527, JString, required = false,
                                 default = newJString("json"))
  if valid_594527 != nil:
    section.add "alt", valid_594527
  var valid_594528 = query.getOrDefault("oauth_token")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "oauth_token", valid_594528
  var valid_594529 = query.getOrDefault("callback")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = nil)
  if valid_594529 != nil:
    section.add "callback", valid_594529
  var valid_594530 = query.getOrDefault("access_token")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "access_token", valid_594530
  var valid_594531 = query.getOrDefault("uploadType")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "uploadType", valid_594531
  var valid_594532 = query.getOrDefault("key")
  valid_594532 = validateParameter(valid_594532, JString, required = false,
                                 default = nil)
  if valid_594532 != nil:
    section.add "key", valid_594532
  var valid_594533 = query.getOrDefault("$.xgafv")
  valid_594533 = validateParameter(valid_594533, JString, required = false,
                                 default = newJString("1"))
  if valid_594533 != nil:
    section.add "$.xgafv", valid_594533
  var valid_594534 = query.getOrDefault("prettyPrint")
  valid_594534 = validateParameter(valid_594534, JBool, required = false,
                                 default = newJBool(true))
  if valid_594534 != nil:
    section.add "prettyPrint", valid_594534
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

proc call*(call_594536: Call_VaultMattersUndelete_594520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undeletes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_594536.validator(path, query, header, formData, body)
  let scheme = call_594536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594536.url(scheme.get, call_594536.host, call_594536.base,
                         call_594536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594536, url, valid)

proc call*(call_594537: Call_VaultMattersUndelete_594520; matterId: string;
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
  var path_594538 = newJObject()
  var query_594539 = newJObject()
  var body_594540 = newJObject()
  add(query_594539, "upload_protocol", newJString(uploadProtocol))
  add(query_594539, "fields", newJString(fields))
  add(query_594539, "quotaUser", newJString(quotaUser))
  add(query_594539, "alt", newJString(alt))
  add(query_594539, "oauth_token", newJString(oauthToken))
  add(query_594539, "callback", newJString(callback))
  add(query_594539, "access_token", newJString(accessToken))
  add(query_594539, "uploadType", newJString(uploadType))
  add(path_594538, "matterId", newJString(matterId))
  add(query_594539, "key", newJString(key))
  add(query_594539, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594540 = body
  add(query_594539, "prettyPrint", newJBool(prettyPrint))
  result = call_594537.call(path_594538, query_594539, nil, nil, body_594540)

var vaultMattersUndelete* = Call_VaultMattersUndelete_594520(
    name: "vaultMattersUndelete", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:undelete",
    validator: validate_VaultMattersUndelete_594521, base: "/",
    url: url_VaultMattersUndelete_594522, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
