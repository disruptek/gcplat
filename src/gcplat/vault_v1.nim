
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
  Call_VaultMattersCreate_579920 = ref object of OpenApiRestCall_579373
proc url_VaultMattersCreate_579922(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_VaultMattersCreate_579921(path: JsonNode; query: JsonNode;
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
  var valid_579923 = query.getOrDefault("key")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "key", valid_579923
  var valid_579924 = query.getOrDefault("prettyPrint")
  valid_579924 = validateParameter(valid_579924, JBool, required = false,
                                 default = newJBool(true))
  if valid_579924 != nil:
    section.add "prettyPrint", valid_579924
  var valid_579925 = query.getOrDefault("oauth_token")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = nil)
  if valid_579925 != nil:
    section.add "oauth_token", valid_579925
  var valid_579926 = query.getOrDefault("$.xgafv")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = newJString("1"))
  if valid_579926 != nil:
    section.add "$.xgafv", valid_579926
  var valid_579927 = query.getOrDefault("alt")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = newJString("json"))
  if valid_579927 != nil:
    section.add "alt", valid_579927
  var valid_579928 = query.getOrDefault("uploadType")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "uploadType", valid_579928
  var valid_579929 = query.getOrDefault("quotaUser")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "quotaUser", valid_579929
  var valid_579930 = query.getOrDefault("callback")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "callback", valid_579930
  var valid_579931 = query.getOrDefault("fields")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "fields", valid_579931
  var valid_579932 = query.getOrDefault("access_token")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "access_token", valid_579932
  var valid_579933 = query.getOrDefault("upload_protocol")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "upload_protocol", valid_579933
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

proc call*(call_579935: Call_VaultMattersCreate_579920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new matter with the given name and description. The initial state
  ## is open, and the owner is the method caller. Returns the created matter
  ## with default view.
  ## 
  let valid = call_579935.validator(path, query, header, formData, body)
  let scheme = call_579935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579935.url(scheme.get, call_579935.host, call_579935.base,
                         call_579935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579935, url, valid)

proc call*(call_579936: Call_VaultMattersCreate_579920; key: string = "";
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
  var query_579937 = newJObject()
  var body_579938 = newJObject()
  add(query_579937, "key", newJString(key))
  add(query_579937, "prettyPrint", newJBool(prettyPrint))
  add(query_579937, "oauth_token", newJString(oauthToken))
  add(query_579937, "$.xgafv", newJString(Xgafv))
  add(query_579937, "alt", newJString(alt))
  add(query_579937, "uploadType", newJString(uploadType))
  add(query_579937, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579938 = body
  add(query_579937, "callback", newJString(callback))
  add(query_579937, "fields", newJString(fields))
  add(query_579937, "access_token", newJString(accessToken))
  add(query_579937, "upload_protocol", newJString(uploadProtocol))
  result = call_579936.call(nil, query_579937, nil, nil, body_579938)

var vaultMattersCreate* = Call_VaultMattersCreate_579920(
    name: "vaultMattersCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters",
    validator: validate_VaultMattersCreate_579921, base: "/",
    url: url_VaultMattersCreate_579922, schemes: {Scheme.Https})
type
  Call_VaultMattersList_579644 = ref object of OpenApiRestCall_579373
proc url_VaultMattersList_579646(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_VaultMattersList_579645(path: JsonNode; query: JsonNode;
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
  var valid_579758 = query.getOrDefault("key")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "key", valid_579758
  var valid_579772 = query.getOrDefault("prettyPrint")
  valid_579772 = validateParameter(valid_579772, JBool, required = false,
                                 default = newJBool(true))
  if valid_579772 != nil:
    section.add "prettyPrint", valid_579772
  var valid_579773 = query.getOrDefault("oauth_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "oauth_token", valid_579773
  var valid_579774 = query.getOrDefault("$.xgafv")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = newJString("1"))
  if valid_579774 != nil:
    section.add "$.xgafv", valid_579774
  var valid_579775 = query.getOrDefault("state")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = newJString("STATE_UNSPECIFIED"))
  if valid_579775 != nil:
    section.add "state", valid_579775
  var valid_579776 = query.getOrDefault("pageSize")
  valid_579776 = validateParameter(valid_579776, JInt, required = false, default = nil)
  if valid_579776 != nil:
    section.add "pageSize", valid_579776
  var valid_579777 = query.getOrDefault("alt")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = newJString("json"))
  if valid_579777 != nil:
    section.add "alt", valid_579777
  var valid_579778 = query.getOrDefault("uploadType")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "uploadType", valid_579778
  var valid_579779 = query.getOrDefault("quotaUser")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "quotaUser", valid_579779
  var valid_579780 = query.getOrDefault("pageToken")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "pageToken", valid_579780
  var valid_579781 = query.getOrDefault("callback")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "callback", valid_579781
  var valid_579782 = query.getOrDefault("fields")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "fields", valid_579782
  var valid_579783 = query.getOrDefault("access_token")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "access_token", valid_579783
  var valid_579784 = query.getOrDefault("upload_protocol")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "upload_protocol", valid_579784
  var valid_579785 = query.getOrDefault("view")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_579785 != nil:
    section.add "view", valid_579785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579808: Call_VaultMattersList_579644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matters the user has access to.
  ## 
  let valid = call_579808.validator(path, query, header, formData, body)
  let scheme = call_579808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579808.url(scheme.get, call_579808.host, call_579808.base,
                         call_579808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579808, url, valid)

proc call*(call_579879: Call_VaultMattersList_579644; key: string = "";
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
  var query_579880 = newJObject()
  add(query_579880, "key", newJString(key))
  add(query_579880, "prettyPrint", newJBool(prettyPrint))
  add(query_579880, "oauth_token", newJString(oauthToken))
  add(query_579880, "$.xgafv", newJString(Xgafv))
  add(query_579880, "state", newJString(state))
  add(query_579880, "pageSize", newJInt(pageSize))
  add(query_579880, "alt", newJString(alt))
  add(query_579880, "uploadType", newJString(uploadType))
  add(query_579880, "quotaUser", newJString(quotaUser))
  add(query_579880, "pageToken", newJString(pageToken))
  add(query_579880, "callback", newJString(callback))
  add(query_579880, "fields", newJString(fields))
  add(query_579880, "access_token", newJString(accessToken))
  add(query_579880, "upload_protocol", newJString(uploadProtocol))
  add(query_579880, "view", newJString(view))
  result = call_579879.call(nil, query_579880, nil, nil, nil)

var vaultMattersList* = Call_VaultMattersList_579644(name: "vaultMattersList",
    meth: HttpMethod.HttpGet, host: "vault.googleapis.com", route: "/v1/matters",
    validator: validate_VaultMattersList_579645, base: "/",
    url: url_VaultMattersList_579646, schemes: {Scheme.Https})
type
  Call_VaultMattersUpdate_579973 = ref object of OpenApiRestCall_579373
proc url_VaultMattersUpdate_579975(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersUpdate_579974(path: JsonNode; query: JsonNode;
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
  var valid_579976 = path.getOrDefault("matterId")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "matterId", valid_579976
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
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("prettyPrint")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "prettyPrint", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("$.xgafv")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("1"))
  if valid_579980 != nil:
    section.add "$.xgafv", valid_579980
  var valid_579981 = query.getOrDefault("alt")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("json"))
  if valid_579981 != nil:
    section.add "alt", valid_579981
  var valid_579982 = query.getOrDefault("uploadType")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "uploadType", valid_579982
  var valid_579983 = query.getOrDefault("quotaUser")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "quotaUser", valid_579983
  var valid_579984 = query.getOrDefault("callback")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "callback", valid_579984
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("access_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "access_token", valid_579986
  var valid_579987 = query.getOrDefault("upload_protocol")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "upload_protocol", valid_579987
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

proc call*(call_579989: Call_VaultMattersUpdate_579973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified matter.
  ## This updates only the name and description of the matter, identified by
  ## matter id. Changes to any other fields are ignored.
  ## Returns the default view of the matter.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_VaultMattersUpdate_579973; matterId: string;
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
  var path_579991 = newJObject()
  var query_579992 = newJObject()
  var body_579993 = newJObject()
  add(query_579992, "key", newJString(key))
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(query_579992, "$.xgafv", newJString(Xgafv))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "uploadType", newJString(uploadType))
  add(query_579992, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579993 = body
  add(query_579992, "callback", newJString(callback))
  add(path_579991, "matterId", newJString(matterId))
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "access_token", newJString(accessToken))
  add(query_579992, "upload_protocol", newJString(uploadProtocol))
  result = call_579990.call(path_579991, query_579992, nil, nil, body_579993)

var vaultMattersUpdate* = Call_VaultMattersUpdate_579973(
    name: "vaultMattersUpdate", meth: HttpMethod.HttpPut,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}",
    validator: validate_VaultMattersUpdate_579974, base: "/",
    url: url_VaultMattersUpdate_579975, schemes: {Scheme.Https})
type
  Call_VaultMattersGet_579939 = ref object of OpenApiRestCall_579373
proc url_VaultMattersGet_579941(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersGet_579940(path: JsonNode; query: JsonNode;
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
  var valid_579956 = path.getOrDefault("matterId")
  valid_579956 = validateParameter(valid_579956, JString, required = true,
                                 default = nil)
  if valid_579956 != nil:
    section.add "matterId", valid_579956
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
  var valid_579957 = query.getOrDefault("key")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "key", valid_579957
  var valid_579958 = query.getOrDefault("prettyPrint")
  valid_579958 = validateParameter(valid_579958, JBool, required = false,
                                 default = newJBool(true))
  if valid_579958 != nil:
    section.add "prettyPrint", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("$.xgafv")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = newJString("1"))
  if valid_579960 != nil:
    section.add "$.xgafv", valid_579960
  var valid_579961 = query.getOrDefault("alt")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = newJString("json"))
  if valid_579961 != nil:
    section.add "alt", valid_579961
  var valid_579962 = query.getOrDefault("uploadType")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "uploadType", valid_579962
  var valid_579963 = query.getOrDefault("quotaUser")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "quotaUser", valid_579963
  var valid_579964 = query.getOrDefault("callback")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "callback", valid_579964
  var valid_579965 = query.getOrDefault("fields")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "fields", valid_579965
  var valid_579966 = query.getOrDefault("access_token")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "access_token", valid_579966
  var valid_579967 = query.getOrDefault("upload_protocol")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "upload_protocol", valid_579967
  var valid_579968 = query.getOrDefault("view")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_579968 != nil:
    section.add "view", valid_579968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579969: Call_VaultMattersGet_579939; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified matter.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_VaultMattersGet_579939; matterId: string;
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
  var path_579971 = newJObject()
  var query_579972 = newJObject()
  add(query_579972, "key", newJString(key))
  add(query_579972, "prettyPrint", newJBool(prettyPrint))
  add(query_579972, "oauth_token", newJString(oauthToken))
  add(query_579972, "$.xgafv", newJString(Xgafv))
  add(query_579972, "alt", newJString(alt))
  add(query_579972, "uploadType", newJString(uploadType))
  add(query_579972, "quotaUser", newJString(quotaUser))
  add(query_579972, "callback", newJString(callback))
  add(path_579971, "matterId", newJString(matterId))
  add(query_579972, "fields", newJString(fields))
  add(query_579972, "access_token", newJString(accessToken))
  add(query_579972, "upload_protocol", newJString(uploadProtocol))
  add(query_579972, "view", newJString(view))
  result = call_579970.call(path_579971, query_579972, nil, nil, nil)

var vaultMattersGet* = Call_VaultMattersGet_579939(name: "vaultMattersGet",
    meth: HttpMethod.HttpGet, host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}", validator: validate_VaultMattersGet_579940,
    base: "/", url: url_VaultMattersGet_579941, schemes: {Scheme.Https})
type
  Call_VaultMattersDelete_579994 = ref object of OpenApiRestCall_579373
proc url_VaultMattersDelete_579996(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersDelete_579995(path: JsonNode; query: JsonNode;
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
  var valid_579997 = path.getOrDefault("matterId")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "matterId", valid_579997
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
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("prettyPrint")
  valid_579999 = validateParameter(valid_579999, JBool, required = false,
                                 default = newJBool(true))
  if valid_579999 != nil:
    section.add "prettyPrint", valid_579999
  var valid_580000 = query.getOrDefault("oauth_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "oauth_token", valid_580000
  var valid_580001 = query.getOrDefault("$.xgafv")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("1"))
  if valid_580001 != nil:
    section.add "$.xgafv", valid_580001
  var valid_580002 = query.getOrDefault("alt")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = newJString("json"))
  if valid_580002 != nil:
    section.add "alt", valid_580002
  var valid_580003 = query.getOrDefault("uploadType")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "uploadType", valid_580003
  var valid_580004 = query.getOrDefault("quotaUser")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "quotaUser", valid_580004
  var valid_580005 = query.getOrDefault("callback")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "callback", valid_580005
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("access_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "access_token", valid_580007
  var valid_580008 = query.getOrDefault("upload_protocol")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "upload_protocol", valid_580008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580009: Call_VaultMattersDelete_579994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_580009.validator(path, query, header, formData, body)
  let scheme = call_580009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580009.url(scheme.get, call_580009.host, call_580009.base,
                         call_580009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580009, url, valid)

proc call*(call_580010: Call_VaultMattersDelete_579994; matterId: string;
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
  var path_580011 = newJObject()
  var query_580012 = newJObject()
  add(query_580012, "key", newJString(key))
  add(query_580012, "prettyPrint", newJBool(prettyPrint))
  add(query_580012, "oauth_token", newJString(oauthToken))
  add(query_580012, "$.xgafv", newJString(Xgafv))
  add(query_580012, "alt", newJString(alt))
  add(query_580012, "uploadType", newJString(uploadType))
  add(query_580012, "quotaUser", newJString(quotaUser))
  add(query_580012, "callback", newJString(callback))
  add(path_580011, "matterId", newJString(matterId))
  add(query_580012, "fields", newJString(fields))
  add(query_580012, "access_token", newJString(accessToken))
  add(query_580012, "upload_protocol", newJString(uploadProtocol))
  result = call_580010.call(path_580011, query_580012, nil, nil, nil)

var vaultMattersDelete* = Call_VaultMattersDelete_579994(
    name: "vaultMattersDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}",
    validator: validate_VaultMattersDelete_579995, base: "/",
    url: url_VaultMattersDelete_579996, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsCreate_580034 = ref object of OpenApiRestCall_579373
proc url_VaultMattersExportsCreate_580036(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersExportsCreate_580035(path: JsonNode; query: JsonNode;
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
  var valid_580037 = path.getOrDefault("matterId")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "matterId", valid_580037
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
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("prettyPrint")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(true))
  if valid_580039 != nil:
    section.add "prettyPrint", valid_580039
  var valid_580040 = query.getOrDefault("oauth_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "oauth_token", valid_580040
  var valid_580041 = query.getOrDefault("$.xgafv")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("1"))
  if valid_580041 != nil:
    section.add "$.xgafv", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("uploadType")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "uploadType", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("callback")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "callback", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("access_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "access_token", valid_580047
  var valid_580048 = query.getOrDefault("upload_protocol")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "upload_protocol", valid_580048
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

proc call*(call_580050: Call_VaultMattersExportsCreate_580034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an Export.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_VaultMattersExportsCreate_580034; matterId: string;
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
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  var body_580054 = newJObject()
  add(query_580053, "key", newJString(key))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "$.xgafv", newJString(Xgafv))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "uploadType", newJString(uploadType))
  add(query_580053, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580054 = body
  add(query_580053, "callback", newJString(callback))
  add(path_580052, "matterId", newJString(matterId))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "access_token", newJString(accessToken))
  add(query_580053, "upload_protocol", newJString(uploadProtocol))
  result = call_580051.call(path_580052, query_580053, nil, nil, body_580054)

var vaultMattersExportsCreate* = Call_VaultMattersExportsCreate_580034(
    name: "vaultMattersExportsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/exports",
    validator: validate_VaultMattersExportsCreate_580035, base: "/",
    url: url_VaultMattersExportsCreate_580036, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsList_580013 = ref object of OpenApiRestCall_579373
proc url_VaultMattersExportsList_580015(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersExportsList_580014(path: JsonNode; query: JsonNode;
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
  var valid_580016 = path.getOrDefault("matterId")
  valid_580016 = validateParameter(valid_580016, JString, required = true,
                                 default = nil)
  if valid_580016 != nil:
    section.add "matterId", valid_580016
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
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
  var valid_580019 = query.getOrDefault("oauth_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "oauth_token", valid_580019
  var valid_580020 = query.getOrDefault("$.xgafv")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("1"))
  if valid_580020 != nil:
    section.add "$.xgafv", valid_580020
  var valid_580021 = query.getOrDefault("pageSize")
  valid_580021 = validateParameter(valid_580021, JInt, required = false, default = nil)
  if valid_580021 != nil:
    section.add "pageSize", valid_580021
  var valid_580022 = query.getOrDefault("alt")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("json"))
  if valid_580022 != nil:
    section.add "alt", valid_580022
  var valid_580023 = query.getOrDefault("uploadType")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "uploadType", valid_580023
  var valid_580024 = query.getOrDefault("quotaUser")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "quotaUser", valid_580024
  var valid_580025 = query.getOrDefault("pageToken")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "pageToken", valid_580025
  var valid_580026 = query.getOrDefault("callback")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "callback", valid_580026
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("access_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "access_token", valid_580028
  var valid_580029 = query.getOrDefault("upload_protocol")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "upload_protocol", valid_580029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580030: Call_VaultMattersExportsList_580013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists Exports.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_VaultMattersExportsList_580013; matterId: string;
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
  var path_580032 = newJObject()
  var query_580033 = newJObject()
  add(query_580033, "key", newJString(key))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "$.xgafv", newJString(Xgafv))
  add(query_580033, "pageSize", newJInt(pageSize))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "uploadType", newJString(uploadType))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(query_580033, "pageToken", newJString(pageToken))
  add(query_580033, "callback", newJString(callback))
  add(path_580032, "matterId", newJString(matterId))
  add(query_580033, "fields", newJString(fields))
  add(query_580033, "access_token", newJString(accessToken))
  add(query_580033, "upload_protocol", newJString(uploadProtocol))
  result = call_580031.call(path_580032, query_580033, nil, nil, nil)

var vaultMattersExportsList* = Call_VaultMattersExportsList_580013(
    name: "vaultMattersExportsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/exports",
    validator: validate_VaultMattersExportsList_580014, base: "/",
    url: url_VaultMattersExportsList_580015, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsGet_580055 = ref object of OpenApiRestCall_579373
proc url_VaultMattersExportsGet_580057(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersExportsGet_580056(path: JsonNode; query: JsonNode;
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
  var valid_580058 = path.getOrDefault("exportId")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "exportId", valid_580058
  var valid_580059 = path.getOrDefault("matterId")
  valid_580059 = validateParameter(valid_580059, JString, required = true,
                                 default = nil)
  if valid_580059 != nil:
    section.add "matterId", valid_580059
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
  var valid_580060 = query.getOrDefault("key")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "key", valid_580060
  var valid_580061 = query.getOrDefault("prettyPrint")
  valid_580061 = validateParameter(valid_580061, JBool, required = false,
                                 default = newJBool(true))
  if valid_580061 != nil:
    section.add "prettyPrint", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("$.xgafv")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("1"))
  if valid_580063 != nil:
    section.add "$.xgafv", valid_580063
  var valid_580064 = query.getOrDefault("alt")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("json"))
  if valid_580064 != nil:
    section.add "alt", valid_580064
  var valid_580065 = query.getOrDefault("uploadType")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "uploadType", valid_580065
  var valid_580066 = query.getOrDefault("quotaUser")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "quotaUser", valid_580066
  var valid_580067 = query.getOrDefault("callback")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "callback", valid_580067
  var valid_580068 = query.getOrDefault("fields")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "fields", valid_580068
  var valid_580069 = query.getOrDefault("access_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "access_token", valid_580069
  var valid_580070 = query.getOrDefault("upload_protocol")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "upload_protocol", valid_580070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580071: Call_VaultMattersExportsGet_580055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an Export.
  ## 
  let valid = call_580071.validator(path, query, header, formData, body)
  let scheme = call_580071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580071.url(scheme.get, call_580071.host, call_580071.base,
                         call_580071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580071, url, valid)

proc call*(call_580072: Call_VaultMattersExportsGet_580055; exportId: string;
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
  var path_580073 = newJObject()
  var query_580074 = newJObject()
  add(query_580074, "key", newJString(key))
  add(query_580074, "prettyPrint", newJBool(prettyPrint))
  add(query_580074, "oauth_token", newJString(oauthToken))
  add(path_580073, "exportId", newJString(exportId))
  add(query_580074, "$.xgafv", newJString(Xgafv))
  add(query_580074, "alt", newJString(alt))
  add(query_580074, "uploadType", newJString(uploadType))
  add(query_580074, "quotaUser", newJString(quotaUser))
  add(query_580074, "callback", newJString(callback))
  add(path_580073, "matterId", newJString(matterId))
  add(query_580074, "fields", newJString(fields))
  add(query_580074, "access_token", newJString(accessToken))
  add(query_580074, "upload_protocol", newJString(uploadProtocol))
  result = call_580072.call(path_580073, query_580074, nil, nil, nil)

var vaultMattersExportsGet* = Call_VaultMattersExportsGet_580055(
    name: "vaultMattersExportsGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/exports/{exportId}",
    validator: validate_VaultMattersExportsGet_580056, base: "/",
    url: url_VaultMattersExportsGet_580057, schemes: {Scheme.Https})
type
  Call_VaultMattersExportsDelete_580075 = ref object of OpenApiRestCall_579373
proc url_VaultMattersExportsDelete_580077(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersExportsDelete_580076(path: JsonNode; query: JsonNode;
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
  var valid_580078 = path.getOrDefault("exportId")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "exportId", valid_580078
  var valid_580079 = path.getOrDefault("matterId")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "matterId", valid_580079
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
  var valid_580080 = query.getOrDefault("key")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "key", valid_580080
  var valid_580081 = query.getOrDefault("prettyPrint")
  valid_580081 = validateParameter(valid_580081, JBool, required = false,
                                 default = newJBool(true))
  if valid_580081 != nil:
    section.add "prettyPrint", valid_580081
  var valid_580082 = query.getOrDefault("oauth_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "oauth_token", valid_580082
  var valid_580083 = query.getOrDefault("$.xgafv")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("1"))
  if valid_580083 != nil:
    section.add "$.xgafv", valid_580083
  var valid_580084 = query.getOrDefault("alt")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("json"))
  if valid_580084 != nil:
    section.add "alt", valid_580084
  var valid_580085 = query.getOrDefault("uploadType")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "uploadType", valid_580085
  var valid_580086 = query.getOrDefault("quotaUser")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "quotaUser", valid_580086
  var valid_580087 = query.getOrDefault("callback")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "callback", valid_580087
  var valid_580088 = query.getOrDefault("fields")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "fields", valid_580088
  var valid_580089 = query.getOrDefault("access_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "access_token", valid_580089
  var valid_580090 = query.getOrDefault("upload_protocol")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "upload_protocol", valid_580090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580091: Call_VaultMattersExportsDelete_580075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Export.
  ## 
  let valid = call_580091.validator(path, query, header, formData, body)
  let scheme = call_580091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580091.url(scheme.get, call_580091.host, call_580091.base,
                         call_580091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580091, url, valid)

proc call*(call_580092: Call_VaultMattersExportsDelete_580075; exportId: string;
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
  var path_580093 = newJObject()
  var query_580094 = newJObject()
  add(query_580094, "key", newJString(key))
  add(query_580094, "prettyPrint", newJBool(prettyPrint))
  add(query_580094, "oauth_token", newJString(oauthToken))
  add(path_580093, "exportId", newJString(exportId))
  add(query_580094, "$.xgafv", newJString(Xgafv))
  add(query_580094, "alt", newJString(alt))
  add(query_580094, "uploadType", newJString(uploadType))
  add(query_580094, "quotaUser", newJString(quotaUser))
  add(query_580094, "callback", newJString(callback))
  add(path_580093, "matterId", newJString(matterId))
  add(query_580094, "fields", newJString(fields))
  add(query_580094, "access_token", newJString(accessToken))
  add(query_580094, "upload_protocol", newJString(uploadProtocol))
  result = call_580092.call(path_580093, query_580094, nil, nil, nil)

var vaultMattersExportsDelete* = Call_VaultMattersExportsDelete_580075(
    name: "vaultMattersExportsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/exports/{exportId}",
    validator: validate_VaultMattersExportsDelete_580076, base: "/",
    url: url_VaultMattersExportsDelete_580077, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsCreate_580117 = ref object of OpenApiRestCall_579373
proc url_VaultMattersHoldsCreate_580119(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersHoldsCreate_580118(path: JsonNode; query: JsonNode;
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
  var valid_580120 = path.getOrDefault("matterId")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "matterId", valid_580120
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
  var valid_580121 = query.getOrDefault("key")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "key", valid_580121
  var valid_580122 = query.getOrDefault("prettyPrint")
  valid_580122 = validateParameter(valid_580122, JBool, required = false,
                                 default = newJBool(true))
  if valid_580122 != nil:
    section.add "prettyPrint", valid_580122
  var valid_580123 = query.getOrDefault("oauth_token")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "oauth_token", valid_580123
  var valid_580124 = query.getOrDefault("$.xgafv")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("1"))
  if valid_580124 != nil:
    section.add "$.xgafv", valid_580124
  var valid_580125 = query.getOrDefault("alt")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("json"))
  if valid_580125 != nil:
    section.add "alt", valid_580125
  var valid_580126 = query.getOrDefault("uploadType")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "uploadType", valid_580126
  var valid_580127 = query.getOrDefault("quotaUser")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "quotaUser", valid_580127
  var valid_580128 = query.getOrDefault("callback")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "callback", valid_580128
  var valid_580129 = query.getOrDefault("fields")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "fields", valid_580129
  var valid_580130 = query.getOrDefault("access_token")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "access_token", valid_580130
  var valid_580131 = query.getOrDefault("upload_protocol")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "upload_protocol", valid_580131
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

proc call*(call_580133: Call_VaultMattersHoldsCreate_580117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a hold in the given matter.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_VaultMattersHoldsCreate_580117; matterId: string;
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
  var path_580135 = newJObject()
  var query_580136 = newJObject()
  var body_580137 = newJObject()
  add(query_580136, "key", newJString(key))
  add(query_580136, "prettyPrint", newJBool(prettyPrint))
  add(query_580136, "oauth_token", newJString(oauthToken))
  add(query_580136, "$.xgafv", newJString(Xgafv))
  add(query_580136, "alt", newJString(alt))
  add(query_580136, "uploadType", newJString(uploadType))
  add(query_580136, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580137 = body
  add(query_580136, "callback", newJString(callback))
  add(path_580135, "matterId", newJString(matterId))
  add(query_580136, "fields", newJString(fields))
  add(query_580136, "access_token", newJString(accessToken))
  add(query_580136, "upload_protocol", newJString(uploadProtocol))
  result = call_580134.call(path_580135, query_580136, nil, nil, body_580137)

var vaultMattersHoldsCreate* = Call_VaultMattersHoldsCreate_580117(
    name: "vaultMattersHoldsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds",
    validator: validate_VaultMattersHoldsCreate_580118, base: "/",
    url: url_VaultMattersHoldsCreate_580119, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsList_580095 = ref object of OpenApiRestCall_579373
proc url_VaultMattersHoldsList_580097(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersHoldsList_580096(path: JsonNode; query: JsonNode;
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
  var valid_580098 = path.getOrDefault("matterId")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "matterId", valid_580098
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
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("prettyPrint")
  valid_580100 = validateParameter(valid_580100, JBool, required = false,
                                 default = newJBool(true))
  if valid_580100 != nil:
    section.add "prettyPrint", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("$.xgafv")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("1"))
  if valid_580102 != nil:
    section.add "$.xgafv", valid_580102
  var valid_580103 = query.getOrDefault("pageSize")
  valid_580103 = validateParameter(valid_580103, JInt, required = false, default = nil)
  if valid_580103 != nil:
    section.add "pageSize", valid_580103
  var valid_580104 = query.getOrDefault("alt")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("json"))
  if valid_580104 != nil:
    section.add "alt", valid_580104
  var valid_580105 = query.getOrDefault("uploadType")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "uploadType", valid_580105
  var valid_580106 = query.getOrDefault("quotaUser")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "quotaUser", valid_580106
  var valid_580107 = query.getOrDefault("pageToken")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "pageToken", valid_580107
  var valid_580108 = query.getOrDefault("callback")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "callback", valid_580108
  var valid_580109 = query.getOrDefault("fields")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "fields", valid_580109
  var valid_580110 = query.getOrDefault("access_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "access_token", valid_580110
  var valid_580111 = query.getOrDefault("upload_protocol")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "upload_protocol", valid_580111
  var valid_580112 = query.getOrDefault("view")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = newJString("HOLD_VIEW_UNSPECIFIED"))
  if valid_580112 != nil:
    section.add "view", valid_580112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580113: Call_VaultMattersHoldsList_580095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists holds within a matter. An empty page token in ListHoldsResponse
  ## denotes no more holds to list.
  ## 
  let valid = call_580113.validator(path, query, header, formData, body)
  let scheme = call_580113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580113.url(scheme.get, call_580113.host, call_580113.base,
                         call_580113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580113, url, valid)

proc call*(call_580114: Call_VaultMattersHoldsList_580095; matterId: string;
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
  var path_580115 = newJObject()
  var query_580116 = newJObject()
  add(query_580116, "key", newJString(key))
  add(query_580116, "prettyPrint", newJBool(prettyPrint))
  add(query_580116, "oauth_token", newJString(oauthToken))
  add(query_580116, "$.xgafv", newJString(Xgafv))
  add(query_580116, "pageSize", newJInt(pageSize))
  add(query_580116, "alt", newJString(alt))
  add(query_580116, "uploadType", newJString(uploadType))
  add(query_580116, "quotaUser", newJString(quotaUser))
  add(query_580116, "pageToken", newJString(pageToken))
  add(query_580116, "callback", newJString(callback))
  add(path_580115, "matterId", newJString(matterId))
  add(query_580116, "fields", newJString(fields))
  add(query_580116, "access_token", newJString(accessToken))
  add(query_580116, "upload_protocol", newJString(uploadProtocol))
  add(query_580116, "view", newJString(view))
  result = call_580114.call(path_580115, query_580116, nil, nil, nil)

var vaultMattersHoldsList* = Call_VaultMattersHoldsList_580095(
    name: "vaultMattersHoldsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds",
    validator: validate_VaultMattersHoldsList_580096, base: "/",
    url: url_VaultMattersHoldsList_580097, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsUpdate_580159 = ref object of OpenApiRestCall_579373
proc url_VaultMattersHoldsUpdate_580161(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersHoldsUpdate_580160(path: JsonNode; query: JsonNode;
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
  var valid_580162 = path.getOrDefault("holdId")
  valid_580162 = validateParameter(valid_580162, JString, required = true,
                                 default = nil)
  if valid_580162 != nil:
    section.add "holdId", valid_580162
  var valid_580163 = path.getOrDefault("matterId")
  valid_580163 = validateParameter(valid_580163, JString, required = true,
                                 default = nil)
  if valid_580163 != nil:
    section.add "matterId", valid_580163
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
  var valid_580164 = query.getOrDefault("key")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "key", valid_580164
  var valid_580165 = query.getOrDefault("prettyPrint")
  valid_580165 = validateParameter(valid_580165, JBool, required = false,
                                 default = newJBool(true))
  if valid_580165 != nil:
    section.add "prettyPrint", valid_580165
  var valid_580166 = query.getOrDefault("oauth_token")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "oauth_token", valid_580166
  var valid_580167 = query.getOrDefault("$.xgafv")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = newJString("1"))
  if valid_580167 != nil:
    section.add "$.xgafv", valid_580167
  var valid_580168 = query.getOrDefault("alt")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = newJString("json"))
  if valid_580168 != nil:
    section.add "alt", valid_580168
  var valid_580169 = query.getOrDefault("uploadType")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "uploadType", valid_580169
  var valid_580170 = query.getOrDefault("quotaUser")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "quotaUser", valid_580170
  var valid_580171 = query.getOrDefault("callback")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "callback", valid_580171
  var valid_580172 = query.getOrDefault("fields")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "fields", valid_580172
  var valid_580173 = query.getOrDefault("access_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "access_token", valid_580173
  var valid_580174 = query.getOrDefault("upload_protocol")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "upload_protocol", valid_580174
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

proc call*(call_580176: Call_VaultMattersHoldsUpdate_580159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the OU and/or query parameters of a hold. You cannot add accounts
  ## to a hold that covers an OU, nor can you add OUs to a hold that covers
  ## individual accounts. Accounts listed in the hold will be ignored.
  ## 
  let valid = call_580176.validator(path, query, header, formData, body)
  let scheme = call_580176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580176.url(scheme.get, call_580176.host, call_580176.base,
                         call_580176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580176, url, valid)

proc call*(call_580177: Call_VaultMattersHoldsUpdate_580159; holdId: string;
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
  var path_580178 = newJObject()
  var query_580179 = newJObject()
  var body_580180 = newJObject()
  add(query_580179, "key", newJString(key))
  add(query_580179, "prettyPrint", newJBool(prettyPrint))
  add(query_580179, "oauth_token", newJString(oauthToken))
  add(query_580179, "$.xgafv", newJString(Xgafv))
  add(query_580179, "alt", newJString(alt))
  add(query_580179, "uploadType", newJString(uploadType))
  add(query_580179, "quotaUser", newJString(quotaUser))
  add(path_580178, "holdId", newJString(holdId))
  if body != nil:
    body_580180 = body
  add(query_580179, "callback", newJString(callback))
  add(path_580178, "matterId", newJString(matterId))
  add(query_580179, "fields", newJString(fields))
  add(query_580179, "access_token", newJString(accessToken))
  add(query_580179, "upload_protocol", newJString(uploadProtocol))
  result = call_580177.call(path_580178, query_580179, nil, nil, body_580180)

var vaultMattersHoldsUpdate* = Call_VaultMattersHoldsUpdate_580159(
    name: "vaultMattersHoldsUpdate", meth: HttpMethod.HttpPut,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsUpdate_580160, base: "/",
    url: url_VaultMattersHoldsUpdate_580161, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsGet_580138 = ref object of OpenApiRestCall_579373
proc url_VaultMattersHoldsGet_580140(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersHoldsGet_580139(path: JsonNode; query: JsonNode;
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
  var valid_580141 = path.getOrDefault("holdId")
  valid_580141 = validateParameter(valid_580141, JString, required = true,
                                 default = nil)
  if valid_580141 != nil:
    section.add "holdId", valid_580141
  var valid_580142 = path.getOrDefault("matterId")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "matterId", valid_580142
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
  var valid_580143 = query.getOrDefault("key")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "key", valid_580143
  var valid_580144 = query.getOrDefault("prettyPrint")
  valid_580144 = validateParameter(valid_580144, JBool, required = false,
                                 default = newJBool(true))
  if valid_580144 != nil:
    section.add "prettyPrint", valid_580144
  var valid_580145 = query.getOrDefault("oauth_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "oauth_token", valid_580145
  var valid_580146 = query.getOrDefault("$.xgafv")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("1"))
  if valid_580146 != nil:
    section.add "$.xgafv", valid_580146
  var valid_580147 = query.getOrDefault("alt")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = newJString("json"))
  if valid_580147 != nil:
    section.add "alt", valid_580147
  var valid_580148 = query.getOrDefault("uploadType")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "uploadType", valid_580148
  var valid_580149 = query.getOrDefault("quotaUser")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "quotaUser", valid_580149
  var valid_580150 = query.getOrDefault("callback")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "callback", valid_580150
  var valid_580151 = query.getOrDefault("fields")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "fields", valid_580151
  var valid_580152 = query.getOrDefault("access_token")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "access_token", valid_580152
  var valid_580153 = query.getOrDefault("upload_protocol")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "upload_protocol", valid_580153
  var valid_580154 = query.getOrDefault("view")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("HOLD_VIEW_UNSPECIFIED"))
  if valid_580154 != nil:
    section.add "view", valid_580154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580155: Call_VaultMattersHoldsGet_580138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a hold by ID.
  ## 
  let valid = call_580155.validator(path, query, header, formData, body)
  let scheme = call_580155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580155.url(scheme.get, call_580155.host, call_580155.base,
                         call_580155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580155, url, valid)

proc call*(call_580156: Call_VaultMattersHoldsGet_580138; holdId: string;
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
  var path_580157 = newJObject()
  var query_580158 = newJObject()
  add(query_580158, "key", newJString(key))
  add(query_580158, "prettyPrint", newJBool(prettyPrint))
  add(query_580158, "oauth_token", newJString(oauthToken))
  add(query_580158, "$.xgafv", newJString(Xgafv))
  add(query_580158, "alt", newJString(alt))
  add(query_580158, "uploadType", newJString(uploadType))
  add(query_580158, "quotaUser", newJString(quotaUser))
  add(path_580157, "holdId", newJString(holdId))
  add(query_580158, "callback", newJString(callback))
  add(path_580157, "matterId", newJString(matterId))
  add(query_580158, "fields", newJString(fields))
  add(query_580158, "access_token", newJString(accessToken))
  add(query_580158, "upload_protocol", newJString(uploadProtocol))
  add(query_580158, "view", newJString(view))
  result = call_580156.call(path_580157, query_580158, nil, nil, nil)

var vaultMattersHoldsGet* = Call_VaultMattersHoldsGet_580138(
    name: "vaultMattersHoldsGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsGet_580139, base: "/",
    url: url_VaultMattersHoldsGet_580140, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsDelete_580181 = ref object of OpenApiRestCall_579373
proc url_VaultMattersHoldsDelete_580183(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersHoldsDelete_580182(path: JsonNode; query: JsonNode;
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
  var valid_580184 = path.getOrDefault("holdId")
  valid_580184 = validateParameter(valid_580184, JString, required = true,
                                 default = nil)
  if valid_580184 != nil:
    section.add "holdId", valid_580184
  var valid_580185 = path.getOrDefault("matterId")
  valid_580185 = validateParameter(valid_580185, JString, required = true,
                                 default = nil)
  if valid_580185 != nil:
    section.add "matterId", valid_580185
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
  var valid_580186 = query.getOrDefault("key")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "key", valid_580186
  var valid_580187 = query.getOrDefault("prettyPrint")
  valid_580187 = validateParameter(valid_580187, JBool, required = false,
                                 default = newJBool(true))
  if valid_580187 != nil:
    section.add "prettyPrint", valid_580187
  var valid_580188 = query.getOrDefault("oauth_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "oauth_token", valid_580188
  var valid_580189 = query.getOrDefault("$.xgafv")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = newJString("1"))
  if valid_580189 != nil:
    section.add "$.xgafv", valid_580189
  var valid_580190 = query.getOrDefault("alt")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = newJString("json"))
  if valid_580190 != nil:
    section.add "alt", valid_580190
  var valid_580191 = query.getOrDefault("uploadType")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "uploadType", valid_580191
  var valid_580192 = query.getOrDefault("quotaUser")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "quotaUser", valid_580192
  var valid_580193 = query.getOrDefault("callback")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "callback", valid_580193
  var valid_580194 = query.getOrDefault("fields")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "fields", valid_580194
  var valid_580195 = query.getOrDefault("access_token")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "access_token", valid_580195
  var valid_580196 = query.getOrDefault("upload_protocol")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "upload_protocol", valid_580196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580197: Call_VaultMattersHoldsDelete_580181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a hold by ID. This will release any HeldAccounts on this Hold.
  ## 
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_VaultMattersHoldsDelete_580181; holdId: string;
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
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  add(query_580200, "key", newJString(key))
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(query_580200, "$.xgafv", newJString(Xgafv))
  add(query_580200, "alt", newJString(alt))
  add(query_580200, "uploadType", newJString(uploadType))
  add(query_580200, "quotaUser", newJString(quotaUser))
  add(path_580199, "holdId", newJString(holdId))
  add(query_580200, "callback", newJString(callback))
  add(path_580199, "matterId", newJString(matterId))
  add(query_580200, "fields", newJString(fields))
  add(query_580200, "access_token", newJString(accessToken))
  add(query_580200, "upload_protocol", newJString(uploadProtocol))
  result = call_580198.call(path_580199, query_580200, nil, nil, nil)

var vaultMattersHoldsDelete* = Call_VaultMattersHoldsDelete_580181(
    name: "vaultMattersHoldsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/holds/{holdId}",
    validator: validate_VaultMattersHoldsDelete_580182, base: "/",
    url: url_VaultMattersHoldsDelete_580183, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsCreate_580221 = ref object of OpenApiRestCall_579373
proc url_VaultMattersHoldsAccountsCreate_580223(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersHoldsAccountsCreate_580222(path: JsonNode;
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
  var valid_580224 = path.getOrDefault("holdId")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "holdId", valid_580224
  var valid_580225 = path.getOrDefault("matterId")
  valid_580225 = validateParameter(valid_580225, JString, required = true,
                                 default = nil)
  if valid_580225 != nil:
    section.add "matterId", valid_580225
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
  var valid_580226 = query.getOrDefault("key")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "key", valid_580226
  var valid_580227 = query.getOrDefault("prettyPrint")
  valid_580227 = validateParameter(valid_580227, JBool, required = false,
                                 default = newJBool(true))
  if valid_580227 != nil:
    section.add "prettyPrint", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("$.xgafv")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = newJString("1"))
  if valid_580229 != nil:
    section.add "$.xgafv", valid_580229
  var valid_580230 = query.getOrDefault("alt")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = newJString("json"))
  if valid_580230 != nil:
    section.add "alt", valid_580230
  var valid_580231 = query.getOrDefault("uploadType")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "uploadType", valid_580231
  var valid_580232 = query.getOrDefault("quotaUser")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "quotaUser", valid_580232
  var valid_580233 = query.getOrDefault("callback")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "callback", valid_580233
  var valid_580234 = query.getOrDefault("fields")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "fields", valid_580234
  var valid_580235 = query.getOrDefault("access_token")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "access_token", valid_580235
  var valid_580236 = query.getOrDefault("upload_protocol")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "upload_protocol", valid_580236
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

proc call*(call_580238: Call_VaultMattersHoldsAccountsCreate_580221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a HeldAccount to a hold. Accounts can only be added to a hold that
  ## has no held_org_unit set. Attempting to add an account to an OU-based
  ## hold will result in an error.
  ## 
  let valid = call_580238.validator(path, query, header, formData, body)
  let scheme = call_580238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580238.url(scheme.get, call_580238.host, call_580238.base,
                         call_580238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580238, url, valid)

proc call*(call_580239: Call_VaultMattersHoldsAccountsCreate_580221;
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
  var path_580240 = newJObject()
  var query_580241 = newJObject()
  var body_580242 = newJObject()
  add(query_580241, "key", newJString(key))
  add(query_580241, "prettyPrint", newJBool(prettyPrint))
  add(query_580241, "oauth_token", newJString(oauthToken))
  add(query_580241, "$.xgafv", newJString(Xgafv))
  add(query_580241, "alt", newJString(alt))
  add(query_580241, "uploadType", newJString(uploadType))
  add(query_580241, "quotaUser", newJString(quotaUser))
  add(path_580240, "holdId", newJString(holdId))
  if body != nil:
    body_580242 = body
  add(query_580241, "callback", newJString(callback))
  add(path_580240, "matterId", newJString(matterId))
  add(query_580241, "fields", newJString(fields))
  add(query_580241, "access_token", newJString(accessToken))
  add(query_580241, "upload_protocol", newJString(uploadProtocol))
  result = call_580239.call(path_580240, query_580241, nil, nil, body_580242)

var vaultMattersHoldsAccountsCreate* = Call_VaultMattersHoldsAccountsCreate_580221(
    name: "vaultMattersHoldsAccountsCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts",
    validator: validate_VaultMattersHoldsAccountsCreate_580222, base: "/",
    url: url_VaultMattersHoldsAccountsCreate_580223, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsList_580201 = ref object of OpenApiRestCall_579373
proc url_VaultMattersHoldsAccountsList_580203(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersHoldsAccountsList_580202(path: JsonNode; query: JsonNode;
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
  var valid_580204 = path.getOrDefault("holdId")
  valid_580204 = validateParameter(valid_580204, JString, required = true,
                                 default = nil)
  if valid_580204 != nil:
    section.add "holdId", valid_580204
  var valid_580205 = path.getOrDefault("matterId")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "matterId", valid_580205
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
  var valid_580206 = query.getOrDefault("key")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "key", valid_580206
  var valid_580207 = query.getOrDefault("prettyPrint")
  valid_580207 = validateParameter(valid_580207, JBool, required = false,
                                 default = newJBool(true))
  if valid_580207 != nil:
    section.add "prettyPrint", valid_580207
  var valid_580208 = query.getOrDefault("oauth_token")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "oauth_token", valid_580208
  var valid_580209 = query.getOrDefault("$.xgafv")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = newJString("1"))
  if valid_580209 != nil:
    section.add "$.xgafv", valid_580209
  var valid_580210 = query.getOrDefault("alt")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = newJString("json"))
  if valid_580210 != nil:
    section.add "alt", valid_580210
  var valid_580211 = query.getOrDefault("uploadType")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "uploadType", valid_580211
  var valid_580212 = query.getOrDefault("quotaUser")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "quotaUser", valid_580212
  var valid_580213 = query.getOrDefault("callback")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "callback", valid_580213
  var valid_580214 = query.getOrDefault("fields")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "fields", valid_580214
  var valid_580215 = query.getOrDefault("access_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "access_token", valid_580215
  var valid_580216 = query.getOrDefault("upload_protocol")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "upload_protocol", valid_580216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580217: Call_VaultMattersHoldsAccountsList_580201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists HeldAccounts for a hold. This will only list individually specified
  ## held accounts. If the hold is on an OU, then use
  ## <a href="https://developers.google.com/admin-sdk/">Admin SDK</a>
  ## to enumerate its members.
  ## 
  let valid = call_580217.validator(path, query, header, formData, body)
  let scheme = call_580217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580217.url(scheme.get, call_580217.host, call_580217.base,
                         call_580217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580217, url, valid)

proc call*(call_580218: Call_VaultMattersHoldsAccountsList_580201; holdId: string;
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
  var path_580219 = newJObject()
  var query_580220 = newJObject()
  add(query_580220, "key", newJString(key))
  add(query_580220, "prettyPrint", newJBool(prettyPrint))
  add(query_580220, "oauth_token", newJString(oauthToken))
  add(query_580220, "$.xgafv", newJString(Xgafv))
  add(query_580220, "alt", newJString(alt))
  add(query_580220, "uploadType", newJString(uploadType))
  add(query_580220, "quotaUser", newJString(quotaUser))
  add(path_580219, "holdId", newJString(holdId))
  add(query_580220, "callback", newJString(callback))
  add(path_580219, "matterId", newJString(matterId))
  add(query_580220, "fields", newJString(fields))
  add(query_580220, "access_token", newJString(accessToken))
  add(query_580220, "upload_protocol", newJString(uploadProtocol))
  result = call_580218.call(path_580219, query_580220, nil, nil, nil)

var vaultMattersHoldsAccountsList* = Call_VaultMattersHoldsAccountsList_580201(
    name: "vaultMattersHoldsAccountsList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts",
    validator: validate_VaultMattersHoldsAccountsList_580202, base: "/",
    url: url_VaultMattersHoldsAccountsList_580203, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAccountsDelete_580243 = ref object of OpenApiRestCall_579373
proc url_VaultMattersHoldsAccountsDelete_580245(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersHoldsAccountsDelete_580244(path: JsonNode;
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
  var valid_580246 = path.getOrDefault("holdId")
  valid_580246 = validateParameter(valid_580246, JString, required = true,
                                 default = nil)
  if valid_580246 != nil:
    section.add "holdId", valid_580246
  var valid_580247 = path.getOrDefault("accountId")
  valid_580247 = validateParameter(valid_580247, JString, required = true,
                                 default = nil)
  if valid_580247 != nil:
    section.add "accountId", valid_580247
  var valid_580248 = path.getOrDefault("matterId")
  valid_580248 = validateParameter(valid_580248, JString, required = true,
                                 default = nil)
  if valid_580248 != nil:
    section.add "matterId", valid_580248
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
  var valid_580249 = query.getOrDefault("key")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "key", valid_580249
  var valid_580250 = query.getOrDefault("prettyPrint")
  valid_580250 = validateParameter(valid_580250, JBool, required = false,
                                 default = newJBool(true))
  if valid_580250 != nil:
    section.add "prettyPrint", valid_580250
  var valid_580251 = query.getOrDefault("oauth_token")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "oauth_token", valid_580251
  var valid_580252 = query.getOrDefault("$.xgafv")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = newJString("1"))
  if valid_580252 != nil:
    section.add "$.xgafv", valid_580252
  var valid_580253 = query.getOrDefault("alt")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("json"))
  if valid_580253 != nil:
    section.add "alt", valid_580253
  var valid_580254 = query.getOrDefault("uploadType")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "uploadType", valid_580254
  var valid_580255 = query.getOrDefault("quotaUser")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "quotaUser", valid_580255
  var valid_580256 = query.getOrDefault("callback")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "callback", valid_580256
  var valid_580257 = query.getOrDefault("fields")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "fields", valid_580257
  var valid_580258 = query.getOrDefault("access_token")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "access_token", valid_580258
  var valid_580259 = query.getOrDefault("upload_protocol")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "upload_protocol", valid_580259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580260: Call_VaultMattersHoldsAccountsDelete_580243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a HeldAccount from a hold. If this request leaves the hold with
  ## no held accounts, the hold will not apply to any accounts.
  ## 
  let valid = call_580260.validator(path, query, header, formData, body)
  let scheme = call_580260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580260.url(scheme.get, call_580260.host, call_580260.base,
                         call_580260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580260, url, valid)

proc call*(call_580261: Call_VaultMattersHoldsAccountsDelete_580243;
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
  var path_580262 = newJObject()
  var query_580263 = newJObject()
  add(query_580263, "key", newJString(key))
  add(query_580263, "prettyPrint", newJBool(prettyPrint))
  add(query_580263, "oauth_token", newJString(oauthToken))
  add(query_580263, "$.xgafv", newJString(Xgafv))
  add(query_580263, "alt", newJString(alt))
  add(query_580263, "uploadType", newJString(uploadType))
  add(query_580263, "quotaUser", newJString(quotaUser))
  add(path_580262, "holdId", newJString(holdId))
  add(query_580263, "callback", newJString(callback))
  add(path_580262, "accountId", newJString(accountId))
  add(path_580262, "matterId", newJString(matterId))
  add(query_580263, "fields", newJString(fields))
  add(query_580263, "access_token", newJString(accessToken))
  add(query_580263, "upload_protocol", newJString(uploadProtocol))
  result = call_580261.call(path_580262, query_580263, nil, nil, nil)

var vaultMattersHoldsAccountsDelete* = Call_VaultMattersHoldsAccountsDelete_580243(
    name: "vaultMattersHoldsAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}/accounts/{accountId}",
    validator: validate_VaultMattersHoldsAccountsDelete_580244, base: "/",
    url: url_VaultMattersHoldsAccountsDelete_580245, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsAddHeldAccounts_580264 = ref object of OpenApiRestCall_579373
proc url_VaultMattersHoldsAddHeldAccounts_580266(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersHoldsAddHeldAccounts_580265(path: JsonNode;
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
  var valid_580267 = path.getOrDefault("holdId")
  valid_580267 = validateParameter(valid_580267, JString, required = true,
                                 default = nil)
  if valid_580267 != nil:
    section.add "holdId", valid_580267
  var valid_580268 = path.getOrDefault("matterId")
  valid_580268 = validateParameter(valid_580268, JString, required = true,
                                 default = nil)
  if valid_580268 != nil:
    section.add "matterId", valid_580268
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
  var valid_580269 = query.getOrDefault("key")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "key", valid_580269
  var valid_580270 = query.getOrDefault("prettyPrint")
  valid_580270 = validateParameter(valid_580270, JBool, required = false,
                                 default = newJBool(true))
  if valid_580270 != nil:
    section.add "prettyPrint", valid_580270
  var valid_580271 = query.getOrDefault("oauth_token")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "oauth_token", valid_580271
  var valid_580272 = query.getOrDefault("$.xgafv")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = newJString("1"))
  if valid_580272 != nil:
    section.add "$.xgafv", valid_580272
  var valid_580273 = query.getOrDefault("alt")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = newJString("json"))
  if valid_580273 != nil:
    section.add "alt", valid_580273
  var valid_580274 = query.getOrDefault("uploadType")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "uploadType", valid_580274
  var valid_580275 = query.getOrDefault("quotaUser")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "quotaUser", valid_580275
  var valid_580276 = query.getOrDefault("callback")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "callback", valid_580276
  var valid_580277 = query.getOrDefault("fields")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "fields", valid_580277
  var valid_580278 = query.getOrDefault("access_token")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "access_token", valid_580278
  var valid_580279 = query.getOrDefault("upload_protocol")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "upload_protocol", valid_580279
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

proc call*(call_580281: Call_VaultMattersHoldsAddHeldAccounts_580264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds HeldAccounts to a hold. Returns a list of accounts that have been
  ## successfully added. Accounts can only be added to an existing account-based
  ## hold.
  ## 
  let valid = call_580281.validator(path, query, header, formData, body)
  let scheme = call_580281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580281.url(scheme.get, call_580281.host, call_580281.base,
                         call_580281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580281, url, valid)

proc call*(call_580282: Call_VaultMattersHoldsAddHeldAccounts_580264;
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
  var path_580283 = newJObject()
  var query_580284 = newJObject()
  var body_580285 = newJObject()
  add(query_580284, "key", newJString(key))
  add(query_580284, "prettyPrint", newJBool(prettyPrint))
  add(query_580284, "oauth_token", newJString(oauthToken))
  add(query_580284, "$.xgafv", newJString(Xgafv))
  add(query_580284, "alt", newJString(alt))
  add(query_580284, "uploadType", newJString(uploadType))
  add(query_580284, "quotaUser", newJString(quotaUser))
  add(path_580283, "holdId", newJString(holdId))
  if body != nil:
    body_580285 = body
  add(query_580284, "callback", newJString(callback))
  add(path_580283, "matterId", newJString(matterId))
  add(query_580284, "fields", newJString(fields))
  add(query_580284, "access_token", newJString(accessToken))
  add(query_580284, "upload_protocol", newJString(uploadProtocol))
  result = call_580282.call(path_580283, query_580284, nil, nil, body_580285)

var vaultMattersHoldsAddHeldAccounts* = Call_VaultMattersHoldsAddHeldAccounts_580264(
    name: "vaultMattersHoldsAddHeldAccounts", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}:addHeldAccounts",
    validator: validate_VaultMattersHoldsAddHeldAccounts_580265, base: "/",
    url: url_VaultMattersHoldsAddHeldAccounts_580266, schemes: {Scheme.Https})
type
  Call_VaultMattersHoldsRemoveHeldAccounts_580286 = ref object of OpenApiRestCall_579373
proc url_VaultMattersHoldsRemoveHeldAccounts_580288(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersHoldsRemoveHeldAccounts_580287(path: JsonNode;
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
  var valid_580289 = path.getOrDefault("holdId")
  valid_580289 = validateParameter(valid_580289, JString, required = true,
                                 default = nil)
  if valid_580289 != nil:
    section.add "holdId", valid_580289
  var valid_580290 = path.getOrDefault("matterId")
  valid_580290 = validateParameter(valid_580290, JString, required = true,
                                 default = nil)
  if valid_580290 != nil:
    section.add "matterId", valid_580290
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
  var valid_580291 = query.getOrDefault("key")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "key", valid_580291
  var valid_580292 = query.getOrDefault("prettyPrint")
  valid_580292 = validateParameter(valid_580292, JBool, required = false,
                                 default = newJBool(true))
  if valid_580292 != nil:
    section.add "prettyPrint", valid_580292
  var valid_580293 = query.getOrDefault("oauth_token")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "oauth_token", valid_580293
  var valid_580294 = query.getOrDefault("$.xgafv")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = newJString("1"))
  if valid_580294 != nil:
    section.add "$.xgafv", valid_580294
  var valid_580295 = query.getOrDefault("alt")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = newJString("json"))
  if valid_580295 != nil:
    section.add "alt", valid_580295
  var valid_580296 = query.getOrDefault("uploadType")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "uploadType", valid_580296
  var valid_580297 = query.getOrDefault("quotaUser")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "quotaUser", valid_580297
  var valid_580298 = query.getOrDefault("callback")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "callback", valid_580298
  var valid_580299 = query.getOrDefault("fields")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "fields", valid_580299
  var valid_580300 = query.getOrDefault("access_token")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "access_token", valid_580300
  var valid_580301 = query.getOrDefault("upload_protocol")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "upload_protocol", valid_580301
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

proc call*(call_580303: Call_VaultMattersHoldsRemoveHeldAccounts_580286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes HeldAccounts from a hold. Returns a list of statuses in the same
  ## order as the request. If this request leaves the hold with no held
  ## accounts, the hold will not apply to any accounts.
  ## 
  let valid = call_580303.validator(path, query, header, formData, body)
  let scheme = call_580303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580303.url(scheme.get, call_580303.host, call_580303.base,
                         call_580303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580303, url, valid)

proc call*(call_580304: Call_VaultMattersHoldsRemoveHeldAccounts_580286;
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
  var path_580305 = newJObject()
  var query_580306 = newJObject()
  var body_580307 = newJObject()
  add(query_580306, "key", newJString(key))
  add(query_580306, "prettyPrint", newJBool(prettyPrint))
  add(query_580306, "oauth_token", newJString(oauthToken))
  add(query_580306, "$.xgafv", newJString(Xgafv))
  add(query_580306, "alt", newJString(alt))
  add(query_580306, "uploadType", newJString(uploadType))
  add(query_580306, "quotaUser", newJString(quotaUser))
  add(path_580305, "holdId", newJString(holdId))
  if body != nil:
    body_580307 = body
  add(query_580306, "callback", newJString(callback))
  add(path_580305, "matterId", newJString(matterId))
  add(query_580306, "fields", newJString(fields))
  add(query_580306, "access_token", newJString(accessToken))
  add(query_580306, "upload_protocol", newJString(uploadProtocol))
  result = call_580304.call(path_580305, query_580306, nil, nil, body_580307)

var vaultMattersHoldsRemoveHeldAccounts* = Call_VaultMattersHoldsRemoveHeldAccounts_580286(
    name: "vaultMattersHoldsRemoveHeldAccounts", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/holds/{holdId}:removeHeldAccounts",
    validator: validate_VaultMattersHoldsRemoveHeldAccounts_580287, base: "/",
    url: url_VaultMattersHoldsRemoveHeldAccounts_580288, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesCreate_580329 = ref object of OpenApiRestCall_579373
proc url_VaultMattersSavedQueriesCreate_580331(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersSavedQueriesCreate_580330(path: JsonNode;
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
  var valid_580332 = path.getOrDefault("matterId")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "matterId", valid_580332
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
  var valid_580333 = query.getOrDefault("key")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "key", valid_580333
  var valid_580334 = query.getOrDefault("prettyPrint")
  valid_580334 = validateParameter(valid_580334, JBool, required = false,
                                 default = newJBool(true))
  if valid_580334 != nil:
    section.add "prettyPrint", valid_580334
  var valid_580335 = query.getOrDefault("oauth_token")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "oauth_token", valid_580335
  var valid_580336 = query.getOrDefault("$.xgafv")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = newJString("1"))
  if valid_580336 != nil:
    section.add "$.xgafv", valid_580336
  var valid_580337 = query.getOrDefault("alt")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = newJString("json"))
  if valid_580337 != nil:
    section.add "alt", valid_580337
  var valid_580338 = query.getOrDefault("uploadType")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "uploadType", valid_580338
  var valid_580339 = query.getOrDefault("quotaUser")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "quotaUser", valid_580339
  var valid_580340 = query.getOrDefault("callback")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "callback", valid_580340
  var valid_580341 = query.getOrDefault("fields")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "fields", valid_580341
  var valid_580342 = query.getOrDefault("access_token")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "access_token", valid_580342
  var valid_580343 = query.getOrDefault("upload_protocol")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "upload_protocol", valid_580343
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

proc call*(call_580345: Call_VaultMattersSavedQueriesCreate_580329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a saved query.
  ## 
  let valid = call_580345.validator(path, query, header, formData, body)
  let scheme = call_580345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580345.url(scheme.get, call_580345.host, call_580345.base,
                         call_580345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580345, url, valid)

proc call*(call_580346: Call_VaultMattersSavedQueriesCreate_580329;
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
  var path_580347 = newJObject()
  var query_580348 = newJObject()
  var body_580349 = newJObject()
  add(query_580348, "key", newJString(key))
  add(query_580348, "prettyPrint", newJBool(prettyPrint))
  add(query_580348, "oauth_token", newJString(oauthToken))
  add(query_580348, "$.xgafv", newJString(Xgafv))
  add(query_580348, "alt", newJString(alt))
  add(query_580348, "uploadType", newJString(uploadType))
  add(query_580348, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580349 = body
  add(query_580348, "callback", newJString(callback))
  add(path_580347, "matterId", newJString(matterId))
  add(query_580348, "fields", newJString(fields))
  add(query_580348, "access_token", newJString(accessToken))
  add(query_580348, "upload_protocol", newJString(uploadProtocol))
  result = call_580346.call(path_580347, query_580348, nil, nil, body_580349)

var vaultMattersSavedQueriesCreate* = Call_VaultMattersSavedQueriesCreate_580329(
    name: "vaultMattersSavedQueriesCreate", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/savedQueries",
    validator: validate_VaultMattersSavedQueriesCreate_580330, base: "/",
    url: url_VaultMattersSavedQueriesCreate_580331, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesList_580308 = ref object of OpenApiRestCall_579373
proc url_VaultMattersSavedQueriesList_580310(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersSavedQueriesList_580309(path: JsonNode; query: JsonNode;
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
  var valid_580311 = path.getOrDefault("matterId")
  valid_580311 = validateParameter(valid_580311, JString, required = true,
                                 default = nil)
  if valid_580311 != nil:
    section.add "matterId", valid_580311
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
  var valid_580312 = query.getOrDefault("key")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "key", valid_580312
  var valid_580313 = query.getOrDefault("prettyPrint")
  valid_580313 = validateParameter(valid_580313, JBool, required = false,
                                 default = newJBool(true))
  if valid_580313 != nil:
    section.add "prettyPrint", valid_580313
  var valid_580314 = query.getOrDefault("oauth_token")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "oauth_token", valid_580314
  var valid_580315 = query.getOrDefault("$.xgafv")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = newJString("1"))
  if valid_580315 != nil:
    section.add "$.xgafv", valid_580315
  var valid_580316 = query.getOrDefault("pageSize")
  valid_580316 = validateParameter(valid_580316, JInt, required = false, default = nil)
  if valid_580316 != nil:
    section.add "pageSize", valid_580316
  var valid_580317 = query.getOrDefault("alt")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = newJString("json"))
  if valid_580317 != nil:
    section.add "alt", valid_580317
  var valid_580318 = query.getOrDefault("uploadType")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "uploadType", valid_580318
  var valid_580319 = query.getOrDefault("quotaUser")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "quotaUser", valid_580319
  var valid_580320 = query.getOrDefault("pageToken")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "pageToken", valid_580320
  var valid_580321 = query.getOrDefault("callback")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "callback", valid_580321
  var valid_580322 = query.getOrDefault("fields")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "fields", valid_580322
  var valid_580323 = query.getOrDefault("access_token")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "access_token", valid_580323
  var valid_580324 = query.getOrDefault("upload_protocol")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "upload_protocol", valid_580324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580325: Call_VaultMattersSavedQueriesList_580308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists saved queries within a matter. An empty page token in
  ## ListSavedQueriesResponse denotes no more saved queries to list.
  ## 
  let valid = call_580325.validator(path, query, header, formData, body)
  let scheme = call_580325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580325.url(scheme.get, call_580325.host, call_580325.base,
                         call_580325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580325, url, valid)

proc call*(call_580326: Call_VaultMattersSavedQueriesList_580308; matterId: string;
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
  var path_580327 = newJObject()
  var query_580328 = newJObject()
  add(query_580328, "key", newJString(key))
  add(query_580328, "prettyPrint", newJBool(prettyPrint))
  add(query_580328, "oauth_token", newJString(oauthToken))
  add(query_580328, "$.xgafv", newJString(Xgafv))
  add(query_580328, "pageSize", newJInt(pageSize))
  add(query_580328, "alt", newJString(alt))
  add(query_580328, "uploadType", newJString(uploadType))
  add(query_580328, "quotaUser", newJString(quotaUser))
  add(query_580328, "pageToken", newJString(pageToken))
  add(query_580328, "callback", newJString(callback))
  add(path_580327, "matterId", newJString(matterId))
  add(query_580328, "fields", newJString(fields))
  add(query_580328, "access_token", newJString(accessToken))
  add(query_580328, "upload_protocol", newJString(uploadProtocol))
  result = call_580326.call(path_580327, query_580328, nil, nil, nil)

var vaultMattersSavedQueriesList* = Call_VaultMattersSavedQueriesList_580308(
    name: "vaultMattersSavedQueriesList", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}/savedQueries",
    validator: validate_VaultMattersSavedQueriesList_580309, base: "/",
    url: url_VaultMattersSavedQueriesList_580310, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesGet_580350 = ref object of OpenApiRestCall_579373
proc url_VaultMattersSavedQueriesGet_580352(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersSavedQueriesGet_580351(path: JsonNode; query: JsonNode;
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
  var valid_580353 = path.getOrDefault("savedQueryId")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = nil)
  if valid_580353 != nil:
    section.add "savedQueryId", valid_580353
  var valid_580354 = path.getOrDefault("matterId")
  valid_580354 = validateParameter(valid_580354, JString, required = true,
                                 default = nil)
  if valid_580354 != nil:
    section.add "matterId", valid_580354
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
  var valid_580355 = query.getOrDefault("key")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "key", valid_580355
  var valid_580356 = query.getOrDefault("prettyPrint")
  valid_580356 = validateParameter(valid_580356, JBool, required = false,
                                 default = newJBool(true))
  if valid_580356 != nil:
    section.add "prettyPrint", valid_580356
  var valid_580357 = query.getOrDefault("oauth_token")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "oauth_token", valid_580357
  var valid_580358 = query.getOrDefault("$.xgafv")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = newJString("1"))
  if valid_580358 != nil:
    section.add "$.xgafv", valid_580358
  var valid_580359 = query.getOrDefault("alt")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = newJString("json"))
  if valid_580359 != nil:
    section.add "alt", valid_580359
  var valid_580360 = query.getOrDefault("uploadType")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "uploadType", valid_580360
  var valid_580361 = query.getOrDefault("quotaUser")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "quotaUser", valid_580361
  var valid_580362 = query.getOrDefault("callback")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "callback", valid_580362
  var valid_580363 = query.getOrDefault("fields")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "fields", valid_580363
  var valid_580364 = query.getOrDefault("access_token")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "access_token", valid_580364
  var valid_580365 = query.getOrDefault("upload_protocol")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "upload_protocol", valid_580365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580366: Call_VaultMattersSavedQueriesGet_580350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a saved query by Id.
  ## 
  let valid = call_580366.validator(path, query, header, formData, body)
  let scheme = call_580366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580366.url(scheme.get, call_580366.host, call_580366.base,
                         call_580366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580366, url, valid)

proc call*(call_580367: Call_VaultMattersSavedQueriesGet_580350;
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
  var path_580368 = newJObject()
  var query_580369 = newJObject()
  add(query_580369, "key", newJString(key))
  add(query_580369, "prettyPrint", newJBool(prettyPrint))
  add(query_580369, "oauth_token", newJString(oauthToken))
  add(query_580369, "$.xgafv", newJString(Xgafv))
  add(query_580369, "alt", newJString(alt))
  add(query_580369, "uploadType", newJString(uploadType))
  add(query_580369, "quotaUser", newJString(quotaUser))
  add(path_580368, "savedQueryId", newJString(savedQueryId))
  add(query_580369, "callback", newJString(callback))
  add(path_580368, "matterId", newJString(matterId))
  add(query_580369, "fields", newJString(fields))
  add(query_580369, "access_token", newJString(accessToken))
  add(query_580369, "upload_protocol", newJString(uploadProtocol))
  result = call_580367.call(path_580368, query_580369, nil, nil, nil)

var vaultMattersSavedQueriesGet* = Call_VaultMattersSavedQueriesGet_580350(
    name: "vaultMattersSavedQueriesGet", meth: HttpMethod.HttpGet,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/savedQueries/{savedQueryId}",
    validator: validate_VaultMattersSavedQueriesGet_580351, base: "/",
    url: url_VaultMattersSavedQueriesGet_580352, schemes: {Scheme.Https})
type
  Call_VaultMattersSavedQueriesDelete_580370 = ref object of OpenApiRestCall_579373
proc url_VaultMattersSavedQueriesDelete_580372(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersSavedQueriesDelete_580371(path: JsonNode;
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
  var valid_580373 = path.getOrDefault("savedQueryId")
  valid_580373 = validateParameter(valid_580373, JString, required = true,
                                 default = nil)
  if valid_580373 != nil:
    section.add "savedQueryId", valid_580373
  var valid_580374 = path.getOrDefault("matterId")
  valid_580374 = validateParameter(valid_580374, JString, required = true,
                                 default = nil)
  if valid_580374 != nil:
    section.add "matterId", valid_580374
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
  var valid_580375 = query.getOrDefault("key")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "key", valid_580375
  var valid_580376 = query.getOrDefault("prettyPrint")
  valid_580376 = validateParameter(valid_580376, JBool, required = false,
                                 default = newJBool(true))
  if valid_580376 != nil:
    section.add "prettyPrint", valid_580376
  var valid_580377 = query.getOrDefault("oauth_token")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "oauth_token", valid_580377
  var valid_580378 = query.getOrDefault("$.xgafv")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = newJString("1"))
  if valid_580378 != nil:
    section.add "$.xgafv", valid_580378
  var valid_580379 = query.getOrDefault("alt")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = newJString("json"))
  if valid_580379 != nil:
    section.add "alt", valid_580379
  var valid_580380 = query.getOrDefault("uploadType")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "uploadType", valid_580380
  var valid_580381 = query.getOrDefault("quotaUser")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "quotaUser", valid_580381
  var valid_580382 = query.getOrDefault("callback")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "callback", valid_580382
  var valid_580383 = query.getOrDefault("fields")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "fields", valid_580383
  var valid_580384 = query.getOrDefault("access_token")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "access_token", valid_580384
  var valid_580385 = query.getOrDefault("upload_protocol")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "upload_protocol", valid_580385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580386: Call_VaultMattersSavedQueriesDelete_580370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a saved query by Id.
  ## 
  let valid = call_580386.validator(path, query, header, formData, body)
  let scheme = call_580386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580386.url(scheme.get, call_580386.host, call_580386.base,
                         call_580386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580386, url, valid)

proc call*(call_580387: Call_VaultMattersSavedQueriesDelete_580370;
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
  var path_580388 = newJObject()
  var query_580389 = newJObject()
  add(query_580389, "key", newJString(key))
  add(query_580389, "prettyPrint", newJBool(prettyPrint))
  add(query_580389, "oauth_token", newJString(oauthToken))
  add(query_580389, "$.xgafv", newJString(Xgafv))
  add(query_580389, "alt", newJString(alt))
  add(query_580389, "uploadType", newJString(uploadType))
  add(query_580389, "quotaUser", newJString(quotaUser))
  add(path_580388, "savedQueryId", newJString(savedQueryId))
  add(query_580389, "callback", newJString(callback))
  add(path_580388, "matterId", newJString(matterId))
  add(query_580389, "fields", newJString(fields))
  add(query_580389, "access_token", newJString(accessToken))
  add(query_580389, "upload_protocol", newJString(uploadProtocol))
  result = call_580387.call(path_580388, query_580389, nil, nil, nil)

var vaultMattersSavedQueriesDelete* = Call_VaultMattersSavedQueriesDelete_580370(
    name: "vaultMattersSavedQueriesDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}/savedQueries/{savedQueryId}",
    validator: validate_VaultMattersSavedQueriesDelete_580371, base: "/",
    url: url_VaultMattersSavedQueriesDelete_580372, schemes: {Scheme.Https})
type
  Call_VaultMattersAddPermissions_580390 = ref object of OpenApiRestCall_579373
proc url_VaultMattersAddPermissions_580392(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersAddPermissions_580391(path: JsonNode; query: JsonNode;
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
  var valid_580393 = path.getOrDefault("matterId")
  valid_580393 = validateParameter(valid_580393, JString, required = true,
                                 default = nil)
  if valid_580393 != nil:
    section.add "matterId", valid_580393
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
  var valid_580394 = query.getOrDefault("key")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "key", valid_580394
  var valid_580395 = query.getOrDefault("prettyPrint")
  valid_580395 = validateParameter(valid_580395, JBool, required = false,
                                 default = newJBool(true))
  if valid_580395 != nil:
    section.add "prettyPrint", valid_580395
  var valid_580396 = query.getOrDefault("oauth_token")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "oauth_token", valid_580396
  var valid_580397 = query.getOrDefault("$.xgafv")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = newJString("1"))
  if valid_580397 != nil:
    section.add "$.xgafv", valid_580397
  var valid_580398 = query.getOrDefault("alt")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = newJString("json"))
  if valid_580398 != nil:
    section.add "alt", valid_580398
  var valid_580399 = query.getOrDefault("uploadType")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "uploadType", valid_580399
  var valid_580400 = query.getOrDefault("quotaUser")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "quotaUser", valid_580400
  var valid_580401 = query.getOrDefault("callback")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "callback", valid_580401
  var valid_580402 = query.getOrDefault("fields")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "fields", valid_580402
  var valid_580403 = query.getOrDefault("access_token")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "access_token", valid_580403
  var valid_580404 = query.getOrDefault("upload_protocol")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "upload_protocol", valid_580404
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

proc call*(call_580406: Call_VaultMattersAddPermissions_580390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an account as a matter collaborator.
  ## 
  let valid = call_580406.validator(path, query, header, formData, body)
  let scheme = call_580406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580406.url(scheme.get, call_580406.host, call_580406.base,
                         call_580406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580406, url, valid)

proc call*(call_580407: Call_VaultMattersAddPermissions_580390; matterId: string;
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
  var path_580408 = newJObject()
  var query_580409 = newJObject()
  var body_580410 = newJObject()
  add(query_580409, "key", newJString(key))
  add(query_580409, "prettyPrint", newJBool(prettyPrint))
  add(query_580409, "oauth_token", newJString(oauthToken))
  add(query_580409, "$.xgafv", newJString(Xgafv))
  add(query_580409, "alt", newJString(alt))
  add(query_580409, "uploadType", newJString(uploadType))
  add(query_580409, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580410 = body
  add(query_580409, "callback", newJString(callback))
  add(path_580408, "matterId", newJString(matterId))
  add(query_580409, "fields", newJString(fields))
  add(query_580409, "access_token", newJString(accessToken))
  add(query_580409, "upload_protocol", newJString(uploadProtocol))
  result = call_580407.call(path_580408, query_580409, nil, nil, body_580410)

var vaultMattersAddPermissions* = Call_VaultMattersAddPermissions_580390(
    name: "vaultMattersAddPermissions", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:addPermissions",
    validator: validate_VaultMattersAddPermissions_580391, base: "/",
    url: url_VaultMattersAddPermissions_580392, schemes: {Scheme.Https})
type
  Call_VaultMattersClose_580411 = ref object of OpenApiRestCall_579373
proc url_VaultMattersClose_580413(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersClose_580412(path: JsonNode; query: JsonNode;
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
  var valid_580414 = path.getOrDefault("matterId")
  valid_580414 = validateParameter(valid_580414, JString, required = true,
                                 default = nil)
  if valid_580414 != nil:
    section.add "matterId", valid_580414
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
  var valid_580415 = query.getOrDefault("key")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "key", valid_580415
  var valid_580416 = query.getOrDefault("prettyPrint")
  valid_580416 = validateParameter(valid_580416, JBool, required = false,
                                 default = newJBool(true))
  if valid_580416 != nil:
    section.add "prettyPrint", valid_580416
  var valid_580417 = query.getOrDefault("oauth_token")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "oauth_token", valid_580417
  var valid_580418 = query.getOrDefault("$.xgafv")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("1"))
  if valid_580418 != nil:
    section.add "$.xgafv", valid_580418
  var valid_580419 = query.getOrDefault("alt")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = newJString("json"))
  if valid_580419 != nil:
    section.add "alt", valid_580419
  var valid_580420 = query.getOrDefault("uploadType")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "uploadType", valid_580420
  var valid_580421 = query.getOrDefault("quotaUser")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "quotaUser", valid_580421
  var valid_580422 = query.getOrDefault("callback")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "callback", valid_580422
  var valid_580423 = query.getOrDefault("fields")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "fields", valid_580423
  var valid_580424 = query.getOrDefault("access_token")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "access_token", valid_580424
  var valid_580425 = query.getOrDefault("upload_protocol")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "upload_protocol", valid_580425
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

proc call*(call_580427: Call_VaultMattersClose_580411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Closes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_580427.validator(path, query, header, formData, body)
  let scheme = call_580427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580427.url(scheme.get, call_580427.host, call_580427.base,
                         call_580427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580427, url, valid)

proc call*(call_580428: Call_VaultMattersClose_580411; matterId: string;
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
  var path_580429 = newJObject()
  var query_580430 = newJObject()
  var body_580431 = newJObject()
  add(query_580430, "key", newJString(key))
  add(query_580430, "prettyPrint", newJBool(prettyPrint))
  add(query_580430, "oauth_token", newJString(oauthToken))
  add(query_580430, "$.xgafv", newJString(Xgafv))
  add(query_580430, "alt", newJString(alt))
  add(query_580430, "uploadType", newJString(uploadType))
  add(query_580430, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580431 = body
  add(query_580430, "callback", newJString(callback))
  add(path_580429, "matterId", newJString(matterId))
  add(query_580430, "fields", newJString(fields))
  add(query_580430, "access_token", newJString(accessToken))
  add(query_580430, "upload_protocol", newJString(uploadProtocol))
  result = call_580428.call(path_580429, query_580430, nil, nil, body_580431)

var vaultMattersClose* = Call_VaultMattersClose_580411(name: "vaultMattersClose",
    meth: HttpMethod.HttpPost, host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}:close", validator: validate_VaultMattersClose_580412,
    base: "/", url: url_VaultMattersClose_580413, schemes: {Scheme.Https})
type
  Call_VaultMattersRemovePermissions_580432 = ref object of OpenApiRestCall_579373
proc url_VaultMattersRemovePermissions_580434(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersRemovePermissions_580433(path: JsonNode; query: JsonNode;
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
  var valid_580435 = path.getOrDefault("matterId")
  valid_580435 = validateParameter(valid_580435, JString, required = true,
                                 default = nil)
  if valid_580435 != nil:
    section.add "matterId", valid_580435
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
  var valid_580436 = query.getOrDefault("key")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "key", valid_580436
  var valid_580437 = query.getOrDefault("prettyPrint")
  valid_580437 = validateParameter(valid_580437, JBool, required = false,
                                 default = newJBool(true))
  if valid_580437 != nil:
    section.add "prettyPrint", valid_580437
  var valid_580438 = query.getOrDefault("oauth_token")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "oauth_token", valid_580438
  var valid_580439 = query.getOrDefault("$.xgafv")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = newJString("1"))
  if valid_580439 != nil:
    section.add "$.xgafv", valid_580439
  var valid_580440 = query.getOrDefault("alt")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = newJString("json"))
  if valid_580440 != nil:
    section.add "alt", valid_580440
  var valid_580441 = query.getOrDefault("uploadType")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "uploadType", valid_580441
  var valid_580442 = query.getOrDefault("quotaUser")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "quotaUser", valid_580442
  var valid_580443 = query.getOrDefault("callback")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "callback", valid_580443
  var valid_580444 = query.getOrDefault("fields")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "fields", valid_580444
  var valid_580445 = query.getOrDefault("access_token")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "access_token", valid_580445
  var valid_580446 = query.getOrDefault("upload_protocol")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "upload_protocol", valid_580446
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

proc call*(call_580448: Call_VaultMattersRemovePermissions_580432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an account as a matter collaborator.
  ## 
  let valid = call_580448.validator(path, query, header, formData, body)
  let scheme = call_580448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580448.url(scheme.get, call_580448.host, call_580448.base,
                         call_580448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580448, url, valid)

proc call*(call_580449: Call_VaultMattersRemovePermissions_580432;
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
  var path_580450 = newJObject()
  var query_580451 = newJObject()
  var body_580452 = newJObject()
  add(query_580451, "key", newJString(key))
  add(query_580451, "prettyPrint", newJBool(prettyPrint))
  add(query_580451, "oauth_token", newJString(oauthToken))
  add(query_580451, "$.xgafv", newJString(Xgafv))
  add(query_580451, "alt", newJString(alt))
  add(query_580451, "uploadType", newJString(uploadType))
  add(query_580451, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580452 = body
  add(query_580451, "callback", newJString(callback))
  add(path_580450, "matterId", newJString(matterId))
  add(query_580451, "fields", newJString(fields))
  add(query_580451, "access_token", newJString(accessToken))
  add(query_580451, "upload_protocol", newJString(uploadProtocol))
  result = call_580449.call(path_580450, query_580451, nil, nil, body_580452)

var vaultMattersRemovePermissions* = Call_VaultMattersRemovePermissions_580432(
    name: "vaultMattersRemovePermissions", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com",
    route: "/v1/matters/{matterId}:removePermissions",
    validator: validate_VaultMattersRemovePermissions_580433, base: "/",
    url: url_VaultMattersRemovePermissions_580434, schemes: {Scheme.Https})
type
  Call_VaultMattersReopen_580453 = ref object of OpenApiRestCall_579373
proc url_VaultMattersReopen_580455(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersReopen_580454(path: JsonNode; query: JsonNode;
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
  var valid_580456 = path.getOrDefault("matterId")
  valid_580456 = validateParameter(valid_580456, JString, required = true,
                                 default = nil)
  if valid_580456 != nil:
    section.add "matterId", valid_580456
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
  var valid_580457 = query.getOrDefault("key")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "key", valid_580457
  var valid_580458 = query.getOrDefault("prettyPrint")
  valid_580458 = validateParameter(valid_580458, JBool, required = false,
                                 default = newJBool(true))
  if valid_580458 != nil:
    section.add "prettyPrint", valid_580458
  var valid_580459 = query.getOrDefault("oauth_token")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "oauth_token", valid_580459
  var valid_580460 = query.getOrDefault("$.xgafv")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = newJString("1"))
  if valid_580460 != nil:
    section.add "$.xgafv", valid_580460
  var valid_580461 = query.getOrDefault("alt")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = newJString("json"))
  if valid_580461 != nil:
    section.add "alt", valid_580461
  var valid_580462 = query.getOrDefault("uploadType")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "uploadType", valid_580462
  var valid_580463 = query.getOrDefault("quotaUser")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "quotaUser", valid_580463
  var valid_580464 = query.getOrDefault("callback")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "callback", valid_580464
  var valid_580465 = query.getOrDefault("fields")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "fields", valid_580465
  var valid_580466 = query.getOrDefault("access_token")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "access_token", valid_580466
  var valid_580467 = query.getOrDefault("upload_protocol")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "upload_protocol", valid_580467
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

proc call*(call_580469: Call_VaultMattersReopen_580453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reopens the specified matter. Returns matter with updated state.
  ## 
  let valid = call_580469.validator(path, query, header, formData, body)
  let scheme = call_580469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580469.url(scheme.get, call_580469.host, call_580469.base,
                         call_580469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580469, url, valid)

proc call*(call_580470: Call_VaultMattersReopen_580453; matterId: string;
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
  var path_580471 = newJObject()
  var query_580472 = newJObject()
  var body_580473 = newJObject()
  add(query_580472, "key", newJString(key))
  add(query_580472, "prettyPrint", newJBool(prettyPrint))
  add(query_580472, "oauth_token", newJString(oauthToken))
  add(query_580472, "$.xgafv", newJString(Xgafv))
  add(query_580472, "alt", newJString(alt))
  add(query_580472, "uploadType", newJString(uploadType))
  add(query_580472, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580473 = body
  add(query_580472, "callback", newJString(callback))
  add(path_580471, "matterId", newJString(matterId))
  add(query_580472, "fields", newJString(fields))
  add(query_580472, "access_token", newJString(accessToken))
  add(query_580472, "upload_protocol", newJString(uploadProtocol))
  result = call_580470.call(path_580471, query_580472, nil, nil, body_580473)

var vaultMattersReopen* = Call_VaultMattersReopen_580453(
    name: "vaultMattersReopen", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:reopen",
    validator: validate_VaultMattersReopen_580454, base: "/",
    url: url_VaultMattersReopen_580455, schemes: {Scheme.Https})
type
  Call_VaultMattersUndelete_580474 = ref object of OpenApiRestCall_579373
proc url_VaultMattersUndelete_580476(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultMattersUndelete_580475(path: JsonNode; query: JsonNode;
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
  var valid_580477 = path.getOrDefault("matterId")
  valid_580477 = validateParameter(valid_580477, JString, required = true,
                                 default = nil)
  if valid_580477 != nil:
    section.add "matterId", valid_580477
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
  var valid_580478 = query.getOrDefault("key")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "key", valid_580478
  var valid_580479 = query.getOrDefault("prettyPrint")
  valid_580479 = validateParameter(valid_580479, JBool, required = false,
                                 default = newJBool(true))
  if valid_580479 != nil:
    section.add "prettyPrint", valid_580479
  var valid_580480 = query.getOrDefault("oauth_token")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "oauth_token", valid_580480
  var valid_580481 = query.getOrDefault("$.xgafv")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = newJString("1"))
  if valid_580481 != nil:
    section.add "$.xgafv", valid_580481
  var valid_580482 = query.getOrDefault("alt")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = newJString("json"))
  if valid_580482 != nil:
    section.add "alt", valid_580482
  var valid_580483 = query.getOrDefault("uploadType")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "uploadType", valid_580483
  var valid_580484 = query.getOrDefault("quotaUser")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "quotaUser", valid_580484
  var valid_580485 = query.getOrDefault("callback")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "callback", valid_580485
  var valid_580486 = query.getOrDefault("fields")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "fields", valid_580486
  var valid_580487 = query.getOrDefault("access_token")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "access_token", valid_580487
  var valid_580488 = query.getOrDefault("upload_protocol")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "upload_protocol", valid_580488
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

proc call*(call_580490: Call_VaultMattersUndelete_580474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undeletes the specified matter. Returns matter with updated state.
  ## 
  let valid = call_580490.validator(path, query, header, formData, body)
  let scheme = call_580490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580490.url(scheme.get, call_580490.host, call_580490.base,
                         call_580490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580490, url, valid)

proc call*(call_580491: Call_VaultMattersUndelete_580474; matterId: string;
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
  var path_580492 = newJObject()
  var query_580493 = newJObject()
  var body_580494 = newJObject()
  add(query_580493, "key", newJString(key))
  add(query_580493, "prettyPrint", newJBool(prettyPrint))
  add(query_580493, "oauth_token", newJString(oauthToken))
  add(query_580493, "$.xgafv", newJString(Xgafv))
  add(query_580493, "alt", newJString(alt))
  add(query_580493, "uploadType", newJString(uploadType))
  add(query_580493, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580494 = body
  add(query_580493, "callback", newJString(callback))
  add(path_580492, "matterId", newJString(matterId))
  add(query_580493, "fields", newJString(fields))
  add(query_580493, "access_token", newJString(accessToken))
  add(query_580493, "upload_protocol", newJString(uploadProtocol))
  result = call_580491.call(path_580492, query_580493, nil, nil, body_580494)

var vaultMattersUndelete* = Call_VaultMattersUndelete_580474(
    name: "vaultMattersUndelete", meth: HttpMethod.HttpPost,
    host: "vault.googleapis.com", route: "/v1/matters/{matterId}:undelete",
    validator: validate_VaultMattersUndelete_580475, base: "/",
    url: url_VaultMattersUndelete_580476, schemes: {Scheme.Https})
type
  Call_VaultOperationsDelete_580495 = ref object of OpenApiRestCall_579373
proc url_VaultOperationsDelete_580497(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VaultOperationsDelete_580496(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580498 = path.getOrDefault("name")
  valid_580498 = validateParameter(valid_580498, JString, required = true,
                                 default = nil)
  if valid_580498 != nil:
    section.add "name", valid_580498
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
  var valid_580499 = query.getOrDefault("key")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "key", valid_580499
  var valid_580500 = query.getOrDefault("prettyPrint")
  valid_580500 = validateParameter(valid_580500, JBool, required = false,
                                 default = newJBool(true))
  if valid_580500 != nil:
    section.add "prettyPrint", valid_580500
  var valid_580501 = query.getOrDefault("oauth_token")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "oauth_token", valid_580501
  var valid_580502 = query.getOrDefault("$.xgafv")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = newJString("1"))
  if valid_580502 != nil:
    section.add "$.xgafv", valid_580502
  var valid_580503 = query.getOrDefault("alt")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = newJString("json"))
  if valid_580503 != nil:
    section.add "alt", valid_580503
  var valid_580504 = query.getOrDefault("uploadType")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "uploadType", valid_580504
  var valid_580505 = query.getOrDefault("quotaUser")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "quotaUser", valid_580505
  var valid_580506 = query.getOrDefault("callback")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "callback", valid_580506
  var valid_580507 = query.getOrDefault("fields")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "fields", valid_580507
  var valid_580508 = query.getOrDefault("access_token")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "access_token", valid_580508
  var valid_580509 = query.getOrDefault("upload_protocol")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "upload_protocol", valid_580509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580510: Call_VaultOperationsDelete_580495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_580510.validator(path, query, header, formData, body)
  let scheme = call_580510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580510.url(scheme.get, call_580510.host, call_580510.base,
                         call_580510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580510, url, valid)

proc call*(call_580511: Call_VaultOperationsDelete_580495; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## vaultOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
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
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580512 = newJObject()
  var query_580513 = newJObject()
  add(query_580513, "key", newJString(key))
  add(query_580513, "prettyPrint", newJBool(prettyPrint))
  add(query_580513, "oauth_token", newJString(oauthToken))
  add(query_580513, "$.xgafv", newJString(Xgafv))
  add(query_580513, "alt", newJString(alt))
  add(query_580513, "uploadType", newJString(uploadType))
  add(query_580513, "quotaUser", newJString(quotaUser))
  add(path_580512, "name", newJString(name))
  add(query_580513, "callback", newJString(callback))
  add(query_580513, "fields", newJString(fields))
  add(query_580513, "access_token", newJString(accessToken))
  add(query_580513, "upload_protocol", newJString(uploadProtocol))
  result = call_580511.call(path_580512, query_580513, nil, nil, nil)

var vaultOperationsDelete* = Call_VaultOperationsDelete_580495(
    name: "vaultOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "vault.googleapis.com", route: "/v1/{name}",
    validator: validate_VaultOperationsDelete_580496, base: "/",
    url: url_VaultOperationsDelete_580497, schemes: {Scheme.Https})
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
