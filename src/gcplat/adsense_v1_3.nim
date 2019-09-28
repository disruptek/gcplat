
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: AdSense Management
## version: v1.3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses AdSense publishers' inventory and generates performance reports.
## 
## https://developers.google.com/adsense/management/
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
  gcpServiceName = "adsense"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdsenseAccountsList_579693 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsList_579695(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAccountsList_579694(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List all accounts available to this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through accounts. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of accounts to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("pageToken")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "pageToken", valid_579808
  var valid_579809 = query.getOrDefault("quotaUser")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "quotaUser", valid_579809
  var valid_579823 = query.getOrDefault("alt")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("json"))
  if valid_579823 != nil:
    section.add "alt", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("userIp")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "userIp", valid_579825
  var valid_579826 = query.getOrDefault("maxResults")
  valid_579826 = validateParameter(valid_579826, JInt, required = false, default = nil)
  if valid_579826 != nil:
    section.add "maxResults", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("prettyPrint")
  valid_579828 = validateParameter(valid_579828, JBool, required = false,
                                 default = newJBool(true))
  if valid_579828 != nil:
    section.add "prettyPrint", valid_579828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579851: Call_AdsenseAccountsList_579693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accounts available to this AdSense account.
  ## 
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579922: Call_AdsenseAccountsList_579693; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsList
  ## List all accounts available to this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through accounts. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of accounts to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579923 = newJObject()
  add(query_579923, "fields", newJString(fields))
  add(query_579923, "pageToken", newJString(pageToken))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "userIp", newJString(userIp))
  add(query_579923, "maxResults", newJInt(maxResults))
  add(query_579923, "key", newJString(key))
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  result = call_579922.call(nil, query_579923, nil, nil, nil)

var adsenseAccountsList* = Call_AdsenseAccountsList_579693(
    name: "adsenseAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdsenseAccountsList_579694, base: "/adsense/v1.3",
    url: url_AdsenseAccountsList_579695, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsGet_579963 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsGet_579965(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsGet_579964(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get information about the selected AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579980 = path.getOrDefault("accountId")
  valid_579980 = validateParameter(valid_579980, JString, required = true,
                                 default = nil)
  if valid_579980 != nil:
    section.add "accountId", valid_579980
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   tree: JBool
  ##       : Whether the tree of sub accounts should be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579981 = query.getOrDefault("fields")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "fields", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("alt")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("json"))
  if valid_579983 != nil:
    section.add "alt", valid_579983
  var valid_579984 = query.getOrDefault("oauth_token")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "oauth_token", valid_579984
  var valid_579985 = query.getOrDefault("userIp")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "userIp", valid_579985
  var valid_579986 = query.getOrDefault("key")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "key", valid_579986
  var valid_579987 = query.getOrDefault("tree")
  valid_579987 = validateParameter(valid_579987, JBool, required = false, default = nil)
  if valid_579987 != nil:
    section.add "tree", valid_579987
  var valid_579988 = query.getOrDefault("prettyPrint")
  valid_579988 = validateParameter(valid_579988, JBool, required = false,
                                 default = newJBool(true))
  if valid_579988 != nil:
    section.add "prettyPrint", valid_579988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579989: Call_AdsenseAccountsGet_579963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected AdSense account.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_AdsenseAccountsGet_579963; accountId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          tree: bool = false; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsGet
  ## Get information about the selected AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to get information about.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   tree: bool
  ##       : Whether the tree of sub accounts should be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579991 = newJObject()
  var query_579992 = newJObject()
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(path_579991, "accountId", newJString(accountId))
  add(query_579992, "userIp", newJString(userIp))
  add(query_579992, "key", newJString(key))
  add(query_579992, "tree", newJBool(tree))
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  result = call_579990.call(path_579991, query_579992, nil, nil, nil)

var adsenseAccountsGet* = Call_AdsenseAccountsGet_579963(
    name: "adsenseAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdsenseAccountsGet_579964, base: "/adsense/v1.3",
    url: url_AdsenseAccountsGet_579965, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdclientsList_579993 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdclientsList_579995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdclientsList_579994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to list ad clients.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579996 = path.getOrDefault("accountId")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "accountId", valid_579996
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579997 = query.getOrDefault("fields")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "fields", valid_579997
  var valid_579998 = query.getOrDefault("pageToken")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "pageToken", valid_579998
  var valid_579999 = query.getOrDefault("quotaUser")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "quotaUser", valid_579999
  var valid_580000 = query.getOrDefault("alt")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("json"))
  if valid_580000 != nil:
    section.add "alt", valid_580000
  var valid_580001 = query.getOrDefault("oauth_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "oauth_token", valid_580001
  var valid_580002 = query.getOrDefault("userIp")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "userIp", valid_580002
  var valid_580003 = query.getOrDefault("maxResults")
  valid_580003 = validateParameter(valid_580003, JInt, required = false, default = nil)
  if valid_580003 != nil:
    section.add "maxResults", valid_580003
  var valid_580004 = query.getOrDefault("key")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "key", valid_580004
  var valid_580005 = query.getOrDefault("prettyPrint")
  valid_580005 = validateParameter(valid_580005, JBool, required = false,
                                 default = newJBool(true))
  if valid_580005 != nil:
    section.add "prettyPrint", valid_580005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580006: Call_AdsenseAccountsAdclientsList_579993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in the specified account.
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_AdsenseAccountsAdclientsList_579993;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdclientsList
  ## List all ad clients in the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to list ad clients.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "pageToken", newJString(pageToken))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(path_580008, "accountId", newJString(accountId))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "maxResults", newJInt(maxResults))
  add(query_580009, "key", newJString(key))
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(path_580008, query_580009, nil, nil, nil)

var adsenseAccountsAdclientsList* = Call_AdsenseAccountsAdclientsList_579993(
    name: "adsenseAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdsenseAccountsAdclientsList_579994,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdclientsList_579995,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsList_580010 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdunitsList_580012(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdunitsList_580011(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   adClientId: JString (required)
  ##             : Ad client for which to list ad units.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580013 = path.getOrDefault("accountId")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "accountId", valid_580013
  var valid_580014 = path.getOrDefault("adClientId")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "adClientId", valid_580014
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580015 = query.getOrDefault("fields")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "fields", valid_580015
  var valid_580016 = query.getOrDefault("pageToken")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "pageToken", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  var valid_580019 = query.getOrDefault("includeInactive")
  valid_580019 = validateParameter(valid_580019, JBool, required = false, default = nil)
  if valid_580019 != nil:
    section.add "includeInactive", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("userIp")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "userIp", valid_580021
  var valid_580022 = query.getOrDefault("maxResults")
  valid_580022 = validateParameter(valid_580022, JInt, required = false, default = nil)
  if valid_580022 != nil:
    section.add "maxResults", valid_580022
  var valid_580023 = query.getOrDefault("key")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "key", valid_580023
  var valid_580024 = query.getOrDefault("prettyPrint")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(true))
  if valid_580024 != nil:
    section.add "prettyPrint", valid_580024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580025: Call_AdsenseAccountsAdunitsList_580010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for the specified account.
  ## 
  let valid = call_580025.validator(path, query, header, formData, body)
  let scheme = call_580025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580025.url(scheme.get, call_580025.host, call_580025.base,
                         call_580025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580025, url, valid)

proc call*(call_580026: Call_AdsenseAccountsAdunitsList_580010; accountId: string;
          adClientId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; includeInactive: bool = false;
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdunitsList
  ## List all ad units in the specified ad client for the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list ad units.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580027 = newJObject()
  var query_580028 = newJObject()
  add(query_580028, "fields", newJString(fields))
  add(query_580028, "pageToken", newJString(pageToken))
  add(query_580028, "quotaUser", newJString(quotaUser))
  add(query_580028, "alt", newJString(alt))
  add(query_580028, "includeInactive", newJBool(includeInactive))
  add(query_580028, "oauth_token", newJString(oauthToken))
  add(path_580027, "accountId", newJString(accountId))
  add(query_580028, "userIp", newJString(userIp))
  add(query_580028, "maxResults", newJInt(maxResults))
  add(query_580028, "key", newJString(key))
  add(path_580027, "adClientId", newJString(adClientId))
  add(query_580028, "prettyPrint", newJBool(prettyPrint))
  result = call_580026.call(path_580027, query_580028, nil, nil, nil)

var adsenseAccountsAdunitsList* = Call_AdsenseAccountsAdunitsList_580010(
    name: "adsenseAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAccountsAdunitsList_580011, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAdunitsList_580012, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGet_580029 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdunitsGet_580031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdunitsGet_580030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   adClientId: JString (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580032 = path.getOrDefault("accountId")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "accountId", valid_580032
  var valid_580033 = path.getOrDefault("adClientId")
  valid_580033 = validateParameter(valid_580033, JString, required = true,
                                 default = nil)
  if valid_580033 != nil:
    section.add "adClientId", valid_580033
  var valid_580034 = path.getOrDefault("adUnitId")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "adUnitId", valid_580034
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580035 = query.getOrDefault("fields")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "fields", valid_580035
  var valid_580036 = query.getOrDefault("quotaUser")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "quotaUser", valid_580036
  var valid_580037 = query.getOrDefault("alt")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("json"))
  if valid_580037 != nil:
    section.add "alt", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("userIp")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "userIp", valid_580039
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("prettyPrint")
  valid_580041 = validateParameter(valid_580041, JBool, required = false,
                                 default = newJBool(true))
  if valid_580041 != nil:
    section.add "prettyPrint", valid_580041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580042: Call_AdsenseAccountsAdunitsGet_580029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ## 
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_AdsenseAccountsAdunitsGet_580029; accountId: string;
          adClientId: string; adUnitId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdunitsGet
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "quotaUser", newJString(quotaUser))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(path_580044, "accountId", newJString(accountId))
  add(query_580045, "userIp", newJString(userIp))
  add(query_580045, "key", newJString(key))
  add(path_580044, "adClientId", newJString(adClientId))
  add(path_580044, "adUnitId", newJString(adUnitId))
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  result = call_580043.call(path_580044, query_580045, nil, nil, nil)

var adsenseAccountsAdunitsGet* = Call_AdsenseAccountsAdunitsGet_580029(
    name: "adsenseAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAccountsAdunitsGet_580030, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAdunitsGet_580031, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGetAdCode_580046 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdunitsGetAdCode_580048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/adcode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdunitsGetAdCode_580047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get ad code for the specified ad unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get the code for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580049 = path.getOrDefault("accountId")
  valid_580049 = validateParameter(valid_580049, JString, required = true,
                                 default = nil)
  if valid_580049 != nil:
    section.add "accountId", valid_580049
  var valid_580050 = path.getOrDefault("adClientId")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "adClientId", valid_580050
  var valid_580051 = path.getOrDefault("adUnitId")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "adUnitId", valid_580051
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580052 = query.getOrDefault("fields")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "fields", valid_580052
  var valid_580053 = query.getOrDefault("quotaUser")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "quotaUser", valid_580053
  var valid_580054 = query.getOrDefault("alt")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("json"))
  if valid_580054 != nil:
    section.add "alt", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("userIp")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "userIp", valid_580056
  var valid_580057 = query.getOrDefault("key")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "key", valid_580057
  var valid_580058 = query.getOrDefault("prettyPrint")
  valid_580058 = validateParameter(valid_580058, JBool, required = false,
                                 default = newJBool(true))
  if valid_580058 != nil:
    section.add "prettyPrint", valid_580058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580059: Call_AdsenseAccountsAdunitsGetAdCode_580046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_580059.validator(path, query, header, formData, body)
  let scheme = call_580059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580059.url(scheme.get, call_580059.host, call_580059.base,
                         call_580059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580059, url, valid)

proc call*(call_580060: Call_AdsenseAccountsAdunitsGetAdCode_580046;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdunitsGetAdCode
  ## Get ad code for the specified ad unit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580061 = newJObject()
  var query_580062 = newJObject()
  add(query_580062, "fields", newJString(fields))
  add(query_580062, "quotaUser", newJString(quotaUser))
  add(query_580062, "alt", newJString(alt))
  add(query_580062, "oauth_token", newJString(oauthToken))
  add(path_580061, "accountId", newJString(accountId))
  add(query_580062, "userIp", newJString(userIp))
  add(query_580062, "key", newJString(key))
  add(path_580061, "adClientId", newJString(adClientId))
  add(path_580061, "adUnitId", newJString(adUnitId))
  add(query_580062, "prettyPrint", newJBool(prettyPrint))
  result = call_580060.call(path_580061, query_580062, nil, nil, nil)

var adsenseAccountsAdunitsGetAdCode* = Call_AdsenseAccountsAdunitsGetAdCode_580046(
    name: "adsenseAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAccountsAdunitsGetAdCode_580047,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdunitsGetAdCode_580048,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsCustomchannelsList_580063 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdunitsCustomchannelsList_580065(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdunitsCustomchannelsList_580064(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit for which to list custom channels.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580066 = path.getOrDefault("accountId")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "accountId", valid_580066
  var valid_580067 = path.getOrDefault("adClientId")
  valid_580067 = validateParameter(valid_580067, JString, required = true,
                                 default = nil)
  if valid_580067 != nil:
    section.add "adClientId", valid_580067
  var valid_580068 = path.getOrDefault("adUnitId")
  valid_580068 = validateParameter(valid_580068, JString, required = true,
                                 default = nil)
  if valid_580068 != nil:
    section.add "adUnitId", valid_580068
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580069 = query.getOrDefault("fields")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "fields", valid_580069
  var valid_580070 = query.getOrDefault("pageToken")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "pageToken", valid_580070
  var valid_580071 = query.getOrDefault("quotaUser")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "quotaUser", valid_580071
  var valid_580072 = query.getOrDefault("alt")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("json"))
  if valid_580072 != nil:
    section.add "alt", valid_580072
  var valid_580073 = query.getOrDefault("oauth_token")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "oauth_token", valid_580073
  var valid_580074 = query.getOrDefault("userIp")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "userIp", valid_580074
  var valid_580075 = query.getOrDefault("maxResults")
  valid_580075 = validateParameter(valid_580075, JInt, required = false, default = nil)
  if valid_580075 != nil:
    section.add "maxResults", valid_580075
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("prettyPrint")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "prettyPrint", valid_580077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580078: Call_AdsenseAccountsAdunitsCustomchannelsList_580063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_580078.validator(path, query, header, formData, body)
  let scheme = call_580078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580078.url(scheme.get, call_580078.host, call_580078.base,
                         call_580078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580078, url, valid)

proc call*(call_580079: Call_AdsenseAccountsAdunitsCustomchannelsList_580063;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdunitsCustomchannelsList
  ## List all custom channels which the specified ad unit belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580080 = newJObject()
  var query_580081 = newJObject()
  add(query_580081, "fields", newJString(fields))
  add(query_580081, "pageToken", newJString(pageToken))
  add(query_580081, "quotaUser", newJString(quotaUser))
  add(query_580081, "alt", newJString(alt))
  add(query_580081, "oauth_token", newJString(oauthToken))
  add(path_580080, "accountId", newJString(accountId))
  add(query_580081, "userIp", newJString(userIp))
  add(query_580081, "maxResults", newJInt(maxResults))
  add(query_580081, "key", newJString(key))
  add(path_580080, "adClientId", newJString(adClientId))
  add(path_580080, "adUnitId", newJString(adUnitId))
  add(query_580081, "prettyPrint", newJBool(prettyPrint))
  result = call_580079.call(path_580080, query_580081, nil, nil, nil)

var adsenseAccountsAdunitsCustomchannelsList* = Call_AdsenseAccountsAdunitsCustomchannelsList_580063(
    name: "adsenseAccountsAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAccountsAdunitsCustomchannelsList_580064,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdunitsCustomchannelsList_580065,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsList_580082 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsCustomchannelsList_580084(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsCustomchannelsList_580083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels in the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580085 = path.getOrDefault("accountId")
  valid_580085 = validateParameter(valid_580085, JString, required = true,
                                 default = nil)
  if valid_580085 != nil:
    section.add "accountId", valid_580085
  var valid_580086 = path.getOrDefault("adClientId")
  valid_580086 = validateParameter(valid_580086, JString, required = true,
                                 default = nil)
  if valid_580086 != nil:
    section.add "adClientId", valid_580086
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580087 = query.getOrDefault("fields")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "fields", valid_580087
  var valid_580088 = query.getOrDefault("pageToken")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "pageToken", valid_580088
  var valid_580089 = query.getOrDefault("quotaUser")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "quotaUser", valid_580089
  var valid_580090 = query.getOrDefault("alt")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("json"))
  if valid_580090 != nil:
    section.add "alt", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("userIp")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "userIp", valid_580092
  var valid_580093 = query.getOrDefault("maxResults")
  valid_580093 = validateParameter(valid_580093, JInt, required = false, default = nil)
  if valid_580093 != nil:
    section.add "maxResults", valid_580093
  var valid_580094 = query.getOrDefault("key")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "key", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580096: Call_AdsenseAccountsCustomchannelsList_580082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for the specified account.
  ## 
  let valid = call_580096.validator(path, query, header, formData, body)
  let scheme = call_580096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580096.url(scheme.get, call_580096.host, call_580096.base,
                         call_580096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580096, url, valid)

proc call*(call_580097: Call_AdsenseAccountsCustomchannelsList_580082;
          accountId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsCustomchannelsList
  ## List all custom channels in the specified ad client for the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580098 = newJObject()
  var query_580099 = newJObject()
  add(query_580099, "fields", newJString(fields))
  add(query_580099, "pageToken", newJString(pageToken))
  add(query_580099, "quotaUser", newJString(quotaUser))
  add(query_580099, "alt", newJString(alt))
  add(query_580099, "oauth_token", newJString(oauthToken))
  add(path_580098, "accountId", newJString(accountId))
  add(query_580099, "userIp", newJString(userIp))
  add(query_580099, "maxResults", newJInt(maxResults))
  add(query_580099, "key", newJString(key))
  add(path_580098, "adClientId", newJString(adClientId))
  add(query_580099, "prettyPrint", newJBool(prettyPrint))
  result = call_580097.call(path_580098, query_580099, nil, nil, nil)

var adsenseAccountsCustomchannelsList* = Call_AdsenseAccountsCustomchannelsList_580082(
    name: "adsenseAccountsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseAccountsCustomchannelsList_580083,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsList_580084,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsGet_580100 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsCustomchannelsGet_580102(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "customChannelId" in path, "`customChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels/"),
               (kind: VariableSegment, value: "customChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsCustomchannelsGet_580101(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: JString (required)
  ##                  : Custom channel to retrieve.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580103 = path.getOrDefault("accountId")
  valid_580103 = validateParameter(valid_580103, JString, required = true,
                                 default = nil)
  if valid_580103 != nil:
    section.add "accountId", valid_580103
  var valid_580104 = path.getOrDefault("customChannelId")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "customChannelId", valid_580104
  var valid_580105 = path.getOrDefault("adClientId")
  valid_580105 = validateParameter(valid_580105, JString, required = true,
                                 default = nil)
  if valid_580105 != nil:
    section.add "adClientId", valid_580105
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580106 = query.getOrDefault("fields")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "fields", valid_580106
  var valid_580107 = query.getOrDefault("quotaUser")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "quotaUser", valid_580107
  var valid_580108 = query.getOrDefault("alt")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = newJString("json"))
  if valid_580108 != nil:
    section.add "alt", valid_580108
  var valid_580109 = query.getOrDefault("oauth_token")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "oauth_token", valid_580109
  var valid_580110 = query.getOrDefault("userIp")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "userIp", valid_580110
  var valid_580111 = query.getOrDefault("key")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "key", valid_580111
  var valid_580112 = query.getOrDefault("prettyPrint")
  valid_580112 = validateParameter(valid_580112, JBool, required = false,
                                 default = newJBool(true))
  if valid_580112 != nil:
    section.add "prettyPrint", valid_580112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580113: Call_AdsenseAccountsCustomchannelsGet_580100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client for the specified account.
  ## 
  let valid = call_580113.validator(path, query, header, formData, body)
  let scheme = call_580113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580113.url(scheme.get, call_580113.host, call_580113.base,
                         call_580113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580113, url, valid)

proc call*(call_580114: Call_AdsenseAccountsCustomchannelsGet_580100;
          accountId: string; customChannelId: string; adClientId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsCustomchannelsGet
  ## Get the specified custom channel from the specified ad client for the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580115 = newJObject()
  var query_580116 = newJObject()
  add(query_580116, "fields", newJString(fields))
  add(query_580116, "quotaUser", newJString(quotaUser))
  add(query_580116, "alt", newJString(alt))
  add(query_580116, "oauth_token", newJString(oauthToken))
  add(path_580115, "accountId", newJString(accountId))
  add(path_580115, "customChannelId", newJString(customChannelId))
  add(query_580116, "userIp", newJString(userIp))
  add(query_580116, "key", newJString(key))
  add(path_580115, "adClientId", newJString(adClientId))
  add(query_580116, "prettyPrint", newJBool(prettyPrint))
  result = call_580114.call(path_580115, query_580116, nil, nil, nil)

var adsenseAccountsCustomchannelsGet* = Call_AdsenseAccountsCustomchannelsGet_580100(
    name: "adsenseAccountsCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseAccountsCustomchannelsGet_580101,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsGet_580102,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsAdunitsList_580117 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsCustomchannelsAdunitsList_580119(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "customChannelId" in path, "`customChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels/"),
               (kind: VariableSegment, value: "customChannelId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsCustomchannelsAdunitsList_580118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified custom channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: JString (required)
  ##                  : Custom channel for which to list ad units.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580120 = path.getOrDefault("accountId")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "accountId", valid_580120
  var valid_580121 = path.getOrDefault("customChannelId")
  valid_580121 = validateParameter(valid_580121, JString, required = true,
                                 default = nil)
  if valid_580121 != nil:
    section.add "customChannelId", valid_580121
  var valid_580122 = path.getOrDefault("adClientId")
  valid_580122 = validateParameter(valid_580122, JString, required = true,
                                 default = nil)
  if valid_580122 != nil:
    section.add "adClientId", valid_580122
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580123 = query.getOrDefault("fields")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "fields", valid_580123
  var valid_580124 = query.getOrDefault("pageToken")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "pageToken", valid_580124
  var valid_580125 = query.getOrDefault("quotaUser")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "quotaUser", valid_580125
  var valid_580126 = query.getOrDefault("alt")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("json"))
  if valid_580126 != nil:
    section.add "alt", valid_580126
  var valid_580127 = query.getOrDefault("includeInactive")
  valid_580127 = validateParameter(valid_580127, JBool, required = false, default = nil)
  if valid_580127 != nil:
    section.add "includeInactive", valid_580127
  var valid_580128 = query.getOrDefault("oauth_token")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "oauth_token", valid_580128
  var valid_580129 = query.getOrDefault("userIp")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "userIp", valid_580129
  var valid_580130 = query.getOrDefault("maxResults")
  valid_580130 = validateParameter(valid_580130, JInt, required = false, default = nil)
  if valid_580130 != nil:
    section.add "maxResults", valid_580130
  var valid_580131 = query.getOrDefault("key")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "key", valid_580131
  var valid_580132 = query.getOrDefault("prettyPrint")
  valid_580132 = validateParameter(valid_580132, JBool, required = false,
                                 default = newJBool(true))
  if valid_580132 != nil:
    section.add "prettyPrint", valid_580132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580133: Call_AdsenseAccountsCustomchannelsAdunitsList_580117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_AdsenseAccountsCustomchannelsAdunitsList_580117;
          accountId: string; customChannelId: string; adClientId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; includeInactive: bool = false; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsCustomchannelsAdunitsList
  ## List all ad units in the specified custom channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: string (required)
  ##                  : Custom channel for which to list ad units.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580135 = newJObject()
  var query_580136 = newJObject()
  add(query_580136, "fields", newJString(fields))
  add(query_580136, "pageToken", newJString(pageToken))
  add(query_580136, "quotaUser", newJString(quotaUser))
  add(query_580136, "alt", newJString(alt))
  add(query_580136, "includeInactive", newJBool(includeInactive))
  add(query_580136, "oauth_token", newJString(oauthToken))
  add(path_580135, "accountId", newJString(accountId))
  add(path_580135, "customChannelId", newJString(customChannelId))
  add(query_580136, "userIp", newJString(userIp))
  add(query_580136, "maxResults", newJInt(maxResults))
  add(query_580136, "key", newJString(key))
  add(path_580135, "adClientId", newJString(adClientId))
  add(query_580136, "prettyPrint", newJBool(prettyPrint))
  result = call_580134.call(path_580135, query_580136, nil, nil, nil)

var adsenseAccountsCustomchannelsAdunitsList* = Call_AdsenseAccountsCustomchannelsAdunitsList_580117(
    name: "adsenseAccountsCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseAccountsCustomchannelsAdunitsList_580118,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsAdunitsList_580119,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsUrlchannelsList_580137 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsUrlchannelsList_580139(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/urlchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsUrlchannelsList_580138(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all URL channels in the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580140 = path.getOrDefault("accountId")
  valid_580140 = validateParameter(valid_580140, JString, required = true,
                                 default = nil)
  if valid_580140 != nil:
    section.add "accountId", valid_580140
  var valid_580141 = path.getOrDefault("adClientId")
  valid_580141 = validateParameter(valid_580141, JString, required = true,
                                 default = nil)
  if valid_580141 != nil:
    section.add "adClientId", valid_580141
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580142 = query.getOrDefault("fields")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "fields", valid_580142
  var valid_580143 = query.getOrDefault("pageToken")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "pageToken", valid_580143
  var valid_580144 = query.getOrDefault("quotaUser")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "quotaUser", valid_580144
  var valid_580145 = query.getOrDefault("alt")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = newJString("json"))
  if valid_580145 != nil:
    section.add "alt", valid_580145
  var valid_580146 = query.getOrDefault("oauth_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "oauth_token", valid_580146
  var valid_580147 = query.getOrDefault("userIp")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "userIp", valid_580147
  var valid_580148 = query.getOrDefault("maxResults")
  valid_580148 = validateParameter(valid_580148, JInt, required = false, default = nil)
  if valid_580148 != nil:
    section.add "maxResults", valid_580148
  var valid_580149 = query.getOrDefault("key")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "key", valid_580149
  var valid_580150 = query.getOrDefault("prettyPrint")
  valid_580150 = validateParameter(valid_580150, JBool, required = false,
                                 default = newJBool(true))
  if valid_580150 != nil:
    section.add "prettyPrint", valid_580150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580151: Call_AdsenseAccountsUrlchannelsList_580137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for the specified account.
  ## 
  let valid = call_580151.validator(path, query, header, formData, body)
  let scheme = call_580151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580151.url(scheme.get, call_580151.host, call_580151.base,
                         call_580151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580151, url, valid)

proc call*(call_580152: Call_AdsenseAccountsUrlchannelsList_580137;
          accountId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsUrlchannelsList
  ## List all URL channels in the specified ad client for the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580153 = newJObject()
  var query_580154 = newJObject()
  add(query_580154, "fields", newJString(fields))
  add(query_580154, "pageToken", newJString(pageToken))
  add(query_580154, "quotaUser", newJString(quotaUser))
  add(query_580154, "alt", newJString(alt))
  add(query_580154, "oauth_token", newJString(oauthToken))
  add(path_580153, "accountId", newJString(accountId))
  add(query_580154, "userIp", newJString(userIp))
  add(query_580154, "maxResults", newJInt(maxResults))
  add(query_580154, "key", newJString(key))
  add(path_580153, "adClientId", newJString(adClientId))
  add(query_580154, "prettyPrint", newJBool(prettyPrint))
  result = call_580152.call(path_580153, query_580154, nil, nil, nil)

var adsenseAccountsUrlchannelsList* = Call_AdsenseAccountsUrlchannelsList_580137(
    name: "adsenseAccountsUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseAccountsUrlchannelsList_580138,
    base: "/adsense/v1.3", url: url_AdsenseAccountsUrlchannelsList_580139,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAlertsList_580155 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAlertsList_580157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAlertsList_580156(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the alerts for the specified AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to retrieve the alerts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580158 = path.getOrDefault("accountId")
  valid_580158 = validateParameter(valid_580158, JString, required = true,
                                 default = nil)
  if valid_580158 != nil:
    section.add "accountId", valid_580158
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580159 = query.getOrDefault("locale")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "locale", valid_580159
  var valid_580160 = query.getOrDefault("fields")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "fields", valid_580160
  var valid_580161 = query.getOrDefault("quotaUser")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "quotaUser", valid_580161
  var valid_580162 = query.getOrDefault("alt")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = newJString("json"))
  if valid_580162 != nil:
    section.add "alt", valid_580162
  var valid_580163 = query.getOrDefault("oauth_token")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "oauth_token", valid_580163
  var valid_580164 = query.getOrDefault("userIp")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "userIp", valid_580164
  var valid_580165 = query.getOrDefault("key")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "key", valid_580165
  var valid_580166 = query.getOrDefault("prettyPrint")
  valid_580166 = validateParameter(valid_580166, JBool, required = false,
                                 default = newJBool(true))
  if valid_580166 != nil:
    section.add "prettyPrint", valid_580166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580167: Call_AdsenseAccountsAlertsList_580155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for the specified AdSense account.
  ## 
  let valid = call_580167.validator(path, query, header, formData, body)
  let scheme = call_580167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580167.url(scheme.get, call_580167.host, call_580167.base,
                         call_580167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580167, url, valid)

proc call*(call_580168: Call_AdsenseAccountsAlertsList_580155; accountId: string;
          locale: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAlertsList
  ## List the alerts for the specified AdSense account.
  ##   locale: string
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to retrieve the alerts.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580169 = newJObject()
  var query_580170 = newJObject()
  add(query_580170, "locale", newJString(locale))
  add(query_580170, "fields", newJString(fields))
  add(query_580170, "quotaUser", newJString(quotaUser))
  add(query_580170, "alt", newJString(alt))
  add(query_580170, "oauth_token", newJString(oauthToken))
  add(path_580169, "accountId", newJString(accountId))
  add(query_580170, "userIp", newJString(userIp))
  add(query_580170, "key", newJString(key))
  add(query_580170, "prettyPrint", newJBool(prettyPrint))
  result = call_580168.call(path_580169, query_580170, nil, nil, nil)

var adsenseAccountsAlertsList* = Call_AdsenseAccountsAlertsList_580155(
    name: "adsenseAccountsAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts",
    validator: validate_AdsenseAccountsAlertsList_580156, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAlertsList_580157, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsGenerate_580171 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsReportsGenerate_580173(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsReportsGenerate_580172(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account upon which to report.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580174 = path.getOrDefault("accountId")
  valid_580174 = validateParameter(valid_580174, JString, required = true,
                                 default = nil)
  if valid_580174 != nil:
    section.add "accountId", valid_580174
  result.add "path", section
  ## parameters in `query` object:
  ##   useTimezoneReporting: JBool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   currency: JString
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_580175 = query.getOrDefault("useTimezoneReporting")
  valid_580175 = validateParameter(valid_580175, JBool, required = false, default = nil)
  if valid_580175 != nil:
    section.add "useTimezoneReporting", valid_580175
  var valid_580176 = query.getOrDefault("locale")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "locale", valid_580176
  var valid_580177 = query.getOrDefault("fields")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "fields", valid_580177
  var valid_580178 = query.getOrDefault("quotaUser")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "quotaUser", valid_580178
  var valid_580179 = query.getOrDefault("alt")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("json"))
  if valid_580179 != nil:
    section.add "alt", valid_580179
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_580180 = query.getOrDefault("endDate")
  valid_580180 = validateParameter(valid_580180, JString, required = true,
                                 default = nil)
  if valid_580180 != nil:
    section.add "endDate", valid_580180
  var valid_580181 = query.getOrDefault("currency")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "currency", valid_580181
  var valid_580182 = query.getOrDefault("startDate")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "startDate", valid_580182
  var valid_580183 = query.getOrDefault("sort")
  valid_580183 = validateParameter(valid_580183, JArray, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "sort", valid_580183
  var valid_580184 = query.getOrDefault("oauth_token")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "oauth_token", valid_580184
  var valid_580185 = query.getOrDefault("userIp")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "userIp", valid_580185
  var valid_580186 = query.getOrDefault("maxResults")
  valid_580186 = validateParameter(valid_580186, JInt, required = false, default = nil)
  if valid_580186 != nil:
    section.add "maxResults", valid_580186
  var valid_580187 = query.getOrDefault("key")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "key", valid_580187
  var valid_580188 = query.getOrDefault("metric")
  valid_580188 = validateParameter(valid_580188, JArray, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "metric", valid_580188
  var valid_580189 = query.getOrDefault("prettyPrint")
  valid_580189 = validateParameter(valid_580189, JBool, required = false,
                                 default = newJBool(true))
  if valid_580189 != nil:
    section.add "prettyPrint", valid_580189
  var valid_580190 = query.getOrDefault("dimension")
  valid_580190 = validateParameter(valid_580190, JArray, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "dimension", valid_580190
  var valid_580191 = query.getOrDefault("filter")
  valid_580191 = validateParameter(valid_580191, JArray, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "filter", valid_580191
  var valid_580192 = query.getOrDefault("startIndex")
  valid_580192 = validateParameter(valid_580192, JInt, required = false, default = nil)
  if valid_580192 != nil:
    section.add "startIndex", valid_580192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580193: Call_AdsenseAccountsReportsGenerate_580171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_580193.validator(path, query, header, formData, body)
  let scheme = call_580193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580193.url(scheme.get, call_580193.host, call_580193.base,
                         call_580193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580193, url, valid)

proc call*(call_580194: Call_AdsenseAccountsReportsGenerate_580171;
          endDate: string; startDate: string; accountId: string;
          useTimezoneReporting: bool = false; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; currency: string = "";
          sort: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; metric: JsonNode = nil;
          prettyPrint: bool = true; dimension: JsonNode = nil; filter: JsonNode = nil;
          startIndex: int = 0): Recallable =
  ## adsenseAccountsReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   useTimezoneReporting: bool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   currency: string
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account upon which to report.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var path_580195 = newJObject()
  var query_580196 = newJObject()
  add(query_580196, "useTimezoneReporting", newJBool(useTimezoneReporting))
  add(query_580196, "locale", newJString(locale))
  add(query_580196, "fields", newJString(fields))
  add(query_580196, "quotaUser", newJString(quotaUser))
  add(query_580196, "alt", newJString(alt))
  add(query_580196, "endDate", newJString(endDate))
  add(query_580196, "currency", newJString(currency))
  add(query_580196, "startDate", newJString(startDate))
  if sort != nil:
    query_580196.add "sort", sort
  add(query_580196, "oauth_token", newJString(oauthToken))
  add(path_580195, "accountId", newJString(accountId))
  add(query_580196, "userIp", newJString(userIp))
  add(query_580196, "maxResults", newJInt(maxResults))
  add(query_580196, "key", newJString(key))
  if metric != nil:
    query_580196.add "metric", metric
  add(query_580196, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_580196.add "dimension", dimension
  if filter != nil:
    query_580196.add "filter", filter
  add(query_580196, "startIndex", newJInt(startIndex))
  result = call_580194.call(path_580195, query_580196, nil, nil, nil)

var adsenseAccountsReportsGenerate* = Call_AdsenseAccountsReportsGenerate_580171(
    name: "adsenseAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsenseAccountsReportsGenerate_580172,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsGenerate_580173,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedList_580197 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsReportsSavedList_580199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/reports/saved")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsReportsSavedList_580198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in the specified AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the saved reports belong.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580200 = path.getOrDefault("accountId")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "accountId", valid_580200
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580201 = query.getOrDefault("fields")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "fields", valid_580201
  var valid_580202 = query.getOrDefault("pageToken")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "pageToken", valid_580202
  var valid_580203 = query.getOrDefault("quotaUser")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "quotaUser", valid_580203
  var valid_580204 = query.getOrDefault("alt")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("json"))
  if valid_580204 != nil:
    section.add "alt", valid_580204
  var valid_580205 = query.getOrDefault("oauth_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "oauth_token", valid_580205
  var valid_580206 = query.getOrDefault("userIp")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "userIp", valid_580206
  var valid_580207 = query.getOrDefault("maxResults")
  valid_580207 = validateParameter(valid_580207, JInt, required = false, default = nil)
  if valid_580207 != nil:
    section.add "maxResults", valid_580207
  var valid_580208 = query.getOrDefault("key")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "key", valid_580208
  var valid_580209 = query.getOrDefault("prettyPrint")
  valid_580209 = validateParameter(valid_580209, JBool, required = false,
                                 default = newJBool(true))
  if valid_580209 != nil:
    section.add "prettyPrint", valid_580209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580210: Call_AdsenseAccountsReportsSavedList_580197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in the specified AdSense account.
  ## 
  let valid = call_580210.validator(path, query, header, formData, body)
  let scheme = call_580210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580210.url(scheme.get, call_580210.host, call_580210.base,
                         call_580210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580210, url, valid)

proc call*(call_580211: Call_AdsenseAccountsReportsSavedList_580197;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsReportsSavedList
  ## List all saved reports in the specified AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the saved reports belong.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580212 = newJObject()
  var query_580213 = newJObject()
  add(query_580213, "fields", newJString(fields))
  add(query_580213, "pageToken", newJString(pageToken))
  add(query_580213, "quotaUser", newJString(quotaUser))
  add(query_580213, "alt", newJString(alt))
  add(query_580213, "oauth_token", newJString(oauthToken))
  add(path_580212, "accountId", newJString(accountId))
  add(query_580213, "userIp", newJString(userIp))
  add(query_580213, "maxResults", newJInt(maxResults))
  add(query_580213, "key", newJString(key))
  add(query_580213, "prettyPrint", newJBool(prettyPrint))
  result = call_580211.call(path_580212, query_580213, nil, nil, nil)

var adsenseAccountsReportsSavedList* = Call_AdsenseAccountsReportsSavedList_580197(
    name: "adsenseAccountsReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports/saved",
    validator: validate_AdsenseAccountsReportsSavedList_580198,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsSavedList_580199,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedGenerate_580214 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsReportsSavedGenerate_580216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "savedReportId" in path, "`savedReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "savedReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsReportsSavedGenerate_580215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the saved reports belong.
  ##   savedReportId: JString (required)
  ##                : The saved report to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580217 = path.getOrDefault("accountId")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "accountId", valid_580217
  var valid_580218 = path.getOrDefault("savedReportId")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "savedReportId", valid_580218
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_580219 = query.getOrDefault("locale")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "locale", valid_580219
  var valid_580220 = query.getOrDefault("fields")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "fields", valid_580220
  var valid_580221 = query.getOrDefault("quotaUser")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "quotaUser", valid_580221
  var valid_580222 = query.getOrDefault("alt")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = newJString("json"))
  if valid_580222 != nil:
    section.add "alt", valid_580222
  var valid_580223 = query.getOrDefault("oauth_token")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "oauth_token", valid_580223
  var valid_580224 = query.getOrDefault("userIp")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "userIp", valid_580224
  var valid_580225 = query.getOrDefault("maxResults")
  valid_580225 = validateParameter(valid_580225, JInt, required = false, default = nil)
  if valid_580225 != nil:
    section.add "maxResults", valid_580225
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
  var valid_580228 = query.getOrDefault("startIndex")
  valid_580228 = validateParameter(valid_580228, JInt, required = false, default = nil)
  if valid_580228 != nil:
    section.add "startIndex", valid_580228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580229: Call_AdsenseAccountsReportsSavedGenerate_580214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_580229.validator(path, query, header, formData, body)
  let scheme = call_580229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580229.url(scheme.get, call_580229.host, call_580229.base,
                         call_580229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580229, url, valid)

proc call*(call_580230: Call_AdsenseAccountsReportsSavedGenerate_580214;
          accountId: string; savedReportId: string; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## adsenseAccountsReportsSavedGenerate
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the saved reports belong.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var path_580231 = newJObject()
  var query_580232 = newJObject()
  add(query_580232, "locale", newJString(locale))
  add(query_580232, "fields", newJString(fields))
  add(query_580232, "quotaUser", newJString(quotaUser))
  add(query_580232, "alt", newJString(alt))
  add(query_580232, "oauth_token", newJString(oauthToken))
  add(path_580231, "accountId", newJString(accountId))
  add(query_580232, "userIp", newJString(userIp))
  add(path_580231, "savedReportId", newJString(savedReportId))
  add(query_580232, "maxResults", newJInt(maxResults))
  add(query_580232, "key", newJString(key))
  add(query_580232, "prettyPrint", newJBool(prettyPrint))
  add(query_580232, "startIndex", newJInt(startIndex))
  result = call_580230.call(path_580231, query_580232, nil, nil, nil)

var adsenseAccountsReportsSavedGenerate* = Call_AdsenseAccountsReportsSavedGenerate_580214(
    name: "adsenseAccountsReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/reports/{savedReportId}",
    validator: validate_AdsenseAccountsReportsSavedGenerate_580215,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsSavedGenerate_580216,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesList_580233 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsSavedadstylesList_580235(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/savedadstyles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsSavedadstylesList_580234(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved ad styles in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to list saved ad styles.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580236 = path.getOrDefault("accountId")
  valid_580236 = validateParameter(valid_580236, JString, required = true,
                                 default = nil)
  if valid_580236 != nil:
    section.add "accountId", valid_580236
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580237 = query.getOrDefault("fields")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "fields", valid_580237
  var valid_580238 = query.getOrDefault("pageToken")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "pageToken", valid_580238
  var valid_580239 = query.getOrDefault("quotaUser")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "quotaUser", valid_580239
  var valid_580240 = query.getOrDefault("alt")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = newJString("json"))
  if valid_580240 != nil:
    section.add "alt", valid_580240
  var valid_580241 = query.getOrDefault("oauth_token")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "oauth_token", valid_580241
  var valid_580242 = query.getOrDefault("userIp")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "userIp", valid_580242
  var valid_580243 = query.getOrDefault("maxResults")
  valid_580243 = validateParameter(valid_580243, JInt, required = false, default = nil)
  if valid_580243 != nil:
    section.add "maxResults", valid_580243
  var valid_580244 = query.getOrDefault("key")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "key", valid_580244
  var valid_580245 = query.getOrDefault("prettyPrint")
  valid_580245 = validateParameter(valid_580245, JBool, required = false,
                                 default = newJBool(true))
  if valid_580245 != nil:
    section.add "prettyPrint", valid_580245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580246: Call_AdsenseAccountsSavedadstylesList_580233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved ad styles in the specified account.
  ## 
  let valid = call_580246.validator(path, query, header, formData, body)
  let scheme = call_580246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580246.url(scheme.get, call_580246.host, call_580246.base,
                         call_580246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580246, url, valid)

proc call*(call_580247: Call_AdsenseAccountsSavedadstylesList_580233;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsSavedadstylesList
  ## List all saved ad styles in the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to list saved ad styles.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580248 = newJObject()
  var query_580249 = newJObject()
  add(query_580249, "fields", newJString(fields))
  add(query_580249, "pageToken", newJString(pageToken))
  add(query_580249, "quotaUser", newJString(quotaUser))
  add(query_580249, "alt", newJString(alt))
  add(query_580249, "oauth_token", newJString(oauthToken))
  add(path_580248, "accountId", newJString(accountId))
  add(query_580249, "userIp", newJString(userIp))
  add(query_580249, "maxResults", newJInt(maxResults))
  add(query_580249, "key", newJString(key))
  add(query_580249, "prettyPrint", newJBool(prettyPrint))
  result = call_580247.call(path_580248, query_580249, nil, nil, nil)

var adsenseAccountsSavedadstylesList* = Call_AdsenseAccountsSavedadstylesList_580233(
    name: "adsenseAccountsSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/savedadstyles",
    validator: validate_AdsenseAccountsSavedadstylesList_580234,
    base: "/adsense/v1.3", url: url_AdsenseAccountsSavedadstylesList_580235,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesGet_580250 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsSavedadstylesGet_580252(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "savedAdStyleId" in path, "`savedAdStyleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/savedadstyles/"),
               (kind: VariableSegment, value: "savedAdStyleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsSavedadstylesGet_580251(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List a specific saved ad style for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to get the saved ad style.
  ##   savedAdStyleId: JString (required)
  ##                 : Saved ad style to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580253 = path.getOrDefault("accountId")
  valid_580253 = validateParameter(valid_580253, JString, required = true,
                                 default = nil)
  if valid_580253 != nil:
    section.add "accountId", valid_580253
  var valid_580254 = path.getOrDefault("savedAdStyleId")
  valid_580254 = validateParameter(valid_580254, JString, required = true,
                                 default = nil)
  if valid_580254 != nil:
    section.add "savedAdStyleId", valid_580254
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580255 = query.getOrDefault("fields")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "fields", valid_580255
  var valid_580256 = query.getOrDefault("quotaUser")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "quotaUser", valid_580256
  var valid_580257 = query.getOrDefault("alt")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = newJString("json"))
  if valid_580257 != nil:
    section.add "alt", valid_580257
  var valid_580258 = query.getOrDefault("oauth_token")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "oauth_token", valid_580258
  var valid_580259 = query.getOrDefault("userIp")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "userIp", valid_580259
  var valid_580260 = query.getOrDefault("key")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "key", valid_580260
  var valid_580261 = query.getOrDefault("prettyPrint")
  valid_580261 = validateParameter(valid_580261, JBool, required = false,
                                 default = newJBool(true))
  if valid_580261 != nil:
    section.add "prettyPrint", valid_580261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580262: Call_AdsenseAccountsSavedadstylesGet_580250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a specific saved ad style for the specified account.
  ## 
  let valid = call_580262.validator(path, query, header, formData, body)
  let scheme = call_580262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580262.url(scheme.get, call_580262.host, call_580262.base,
                         call_580262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580262, url, valid)

proc call*(call_580263: Call_AdsenseAccountsSavedadstylesGet_580250;
          accountId: string; savedAdStyleId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsSavedadstylesGet
  ## List a specific saved ad style for the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to get the saved ad style.
  ##   savedAdStyleId: string (required)
  ##                 : Saved ad style to retrieve.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580264 = newJObject()
  var query_580265 = newJObject()
  add(query_580265, "fields", newJString(fields))
  add(query_580265, "quotaUser", newJString(quotaUser))
  add(query_580265, "alt", newJString(alt))
  add(query_580265, "oauth_token", newJString(oauthToken))
  add(path_580264, "accountId", newJString(accountId))
  add(path_580264, "savedAdStyleId", newJString(savedAdStyleId))
  add(query_580265, "userIp", newJString(userIp))
  add(query_580265, "key", newJString(key))
  add(query_580265, "prettyPrint", newJBool(prettyPrint))
  result = call_580263.call(path_580264, query_580265, nil, nil, nil)

var adsenseAccountsSavedadstylesGet* = Call_AdsenseAccountsSavedadstylesGet_580250(
    name: "adsenseAccountsSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseAccountsSavedadstylesGet_580251,
    base: "/adsense/v1.3", url: url_AdsenseAccountsSavedadstylesGet_580252,
    schemes: {Scheme.Https})
type
  Call_AdsenseAdclientsList_580266 = ref object of OpenApiRestCall_579424
proc url_AdsenseAdclientsList_580268(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAdclientsList_580267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580269 = query.getOrDefault("fields")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "fields", valid_580269
  var valid_580270 = query.getOrDefault("pageToken")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "pageToken", valid_580270
  var valid_580271 = query.getOrDefault("quotaUser")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "quotaUser", valid_580271
  var valid_580272 = query.getOrDefault("alt")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = newJString("json"))
  if valid_580272 != nil:
    section.add "alt", valid_580272
  var valid_580273 = query.getOrDefault("oauth_token")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "oauth_token", valid_580273
  var valid_580274 = query.getOrDefault("userIp")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "userIp", valid_580274
  var valid_580275 = query.getOrDefault("maxResults")
  valid_580275 = validateParameter(valid_580275, JInt, required = false, default = nil)
  if valid_580275 != nil:
    section.add "maxResults", valid_580275
  var valid_580276 = query.getOrDefault("key")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "key", valid_580276
  var valid_580277 = query.getOrDefault("prettyPrint")
  valid_580277 = validateParameter(valid_580277, JBool, required = false,
                                 default = newJBool(true))
  if valid_580277 != nil:
    section.add "prettyPrint", valid_580277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580278: Call_AdsenseAdclientsList_580266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this AdSense account.
  ## 
  let valid = call_580278.validator(path, query, header, formData, body)
  let scheme = call_580278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580278.url(scheme.get, call_580278.host, call_580278.base,
                         call_580278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580278, url, valid)

proc call*(call_580279: Call_AdsenseAdclientsList_580266; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAdclientsList
  ## List all ad clients in this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580280 = newJObject()
  add(query_580280, "fields", newJString(fields))
  add(query_580280, "pageToken", newJString(pageToken))
  add(query_580280, "quotaUser", newJString(quotaUser))
  add(query_580280, "alt", newJString(alt))
  add(query_580280, "oauth_token", newJString(oauthToken))
  add(query_580280, "userIp", newJString(userIp))
  add(query_580280, "maxResults", newJInt(maxResults))
  add(query_580280, "key", newJString(key))
  add(query_580280, "prettyPrint", newJBool(prettyPrint))
  result = call_580279.call(nil, query_580280, nil, nil, nil)

var adsenseAdclientsList* = Call_AdsenseAdclientsList_580266(
    name: "adsenseAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsenseAdclientsList_580267, base: "/adsense/v1.3",
    url: url_AdsenseAdclientsList_580268, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsList_580281 = ref object of OpenApiRestCall_579424
proc url_AdsenseAdunitsList_580283(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAdunitsList_580282(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List all ad units in the specified ad client for this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list ad units.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580284 = path.getOrDefault("adClientId")
  valid_580284 = validateParameter(valid_580284, JString, required = true,
                                 default = nil)
  if valid_580284 != nil:
    section.add "adClientId", valid_580284
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580285 = query.getOrDefault("fields")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "fields", valid_580285
  var valid_580286 = query.getOrDefault("pageToken")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "pageToken", valid_580286
  var valid_580287 = query.getOrDefault("quotaUser")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "quotaUser", valid_580287
  var valid_580288 = query.getOrDefault("alt")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("json"))
  if valid_580288 != nil:
    section.add "alt", valid_580288
  var valid_580289 = query.getOrDefault("includeInactive")
  valid_580289 = validateParameter(valid_580289, JBool, required = false, default = nil)
  if valid_580289 != nil:
    section.add "includeInactive", valid_580289
  var valid_580290 = query.getOrDefault("oauth_token")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "oauth_token", valid_580290
  var valid_580291 = query.getOrDefault("userIp")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "userIp", valid_580291
  var valid_580292 = query.getOrDefault("maxResults")
  valid_580292 = validateParameter(valid_580292, JInt, required = false, default = nil)
  if valid_580292 != nil:
    section.add "maxResults", valid_580292
  var valid_580293 = query.getOrDefault("key")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "key", valid_580293
  var valid_580294 = query.getOrDefault("prettyPrint")
  valid_580294 = validateParameter(valid_580294, JBool, required = false,
                                 default = newJBool(true))
  if valid_580294 != nil:
    section.add "prettyPrint", valid_580294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580295: Call_AdsenseAdunitsList_580281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this AdSense account.
  ## 
  let valid = call_580295.validator(path, query, header, formData, body)
  let scheme = call_580295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580295.url(scheme.get, call_580295.host, call_580295.base,
                         call_580295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580295, url, valid)

proc call*(call_580296: Call_AdsenseAdunitsList_580281; adClientId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; includeInactive: bool = false; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAdunitsList
  ## List all ad units in the specified ad client for this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list ad units.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580297 = newJObject()
  var query_580298 = newJObject()
  add(query_580298, "fields", newJString(fields))
  add(query_580298, "pageToken", newJString(pageToken))
  add(query_580298, "quotaUser", newJString(quotaUser))
  add(query_580298, "alt", newJString(alt))
  add(query_580298, "includeInactive", newJBool(includeInactive))
  add(query_580298, "oauth_token", newJString(oauthToken))
  add(query_580298, "userIp", newJString(userIp))
  add(query_580298, "maxResults", newJInt(maxResults))
  add(query_580298, "key", newJString(key))
  add(path_580297, "adClientId", newJString(adClientId))
  add(query_580298, "prettyPrint", newJBool(prettyPrint))
  result = call_580296.call(path_580297, query_580298, nil, nil, nil)

var adsenseAdunitsList* = Call_AdsenseAdunitsList_580281(
    name: "adsenseAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAdunitsList_580282, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsList_580283, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGet_580299 = ref object of OpenApiRestCall_579424
proc url_AdsenseAdunitsGet_580301(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAdunitsGet_580300(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580302 = path.getOrDefault("adClientId")
  valid_580302 = validateParameter(valid_580302, JString, required = true,
                                 default = nil)
  if valid_580302 != nil:
    section.add "adClientId", valid_580302
  var valid_580303 = path.getOrDefault("adUnitId")
  valid_580303 = validateParameter(valid_580303, JString, required = true,
                                 default = nil)
  if valid_580303 != nil:
    section.add "adUnitId", valid_580303
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580304 = query.getOrDefault("fields")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "fields", valid_580304
  var valid_580305 = query.getOrDefault("quotaUser")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "quotaUser", valid_580305
  var valid_580306 = query.getOrDefault("alt")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = newJString("json"))
  if valid_580306 != nil:
    section.add "alt", valid_580306
  var valid_580307 = query.getOrDefault("oauth_token")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "oauth_token", valid_580307
  var valid_580308 = query.getOrDefault("userIp")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "userIp", valid_580308
  var valid_580309 = query.getOrDefault("key")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "key", valid_580309
  var valid_580310 = query.getOrDefault("prettyPrint")
  valid_580310 = validateParameter(valid_580310, JBool, required = false,
                                 default = newJBool(true))
  if valid_580310 != nil:
    section.add "prettyPrint", valid_580310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580311: Call_AdsenseAdunitsGet_580299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_580311.validator(path, query, header, formData, body)
  let scheme = call_580311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580311.url(scheme.get, call_580311.host, call_580311.base,
                         call_580311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580311, url, valid)

proc call*(call_580312: Call_AdsenseAdunitsGet_580299; adClientId: string;
          adUnitId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAdunitsGet
  ## Gets the specified ad unit in the specified ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580313 = newJObject()
  var query_580314 = newJObject()
  add(query_580314, "fields", newJString(fields))
  add(query_580314, "quotaUser", newJString(quotaUser))
  add(query_580314, "alt", newJString(alt))
  add(query_580314, "oauth_token", newJString(oauthToken))
  add(query_580314, "userIp", newJString(userIp))
  add(query_580314, "key", newJString(key))
  add(path_580313, "adClientId", newJString(adClientId))
  add(path_580313, "adUnitId", newJString(adUnitId))
  add(query_580314, "prettyPrint", newJBool(prettyPrint))
  result = call_580312.call(path_580313, query_580314, nil, nil, nil)

var adsenseAdunitsGet* = Call_AdsenseAdunitsGet_580299(name: "adsenseAdunitsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAdunitsGet_580300, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsGet_580301, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGetAdCode_580315 = ref object of OpenApiRestCall_579424
proc url_AdsenseAdunitsGetAdCode_580317(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/adcode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAdunitsGetAdCode_580316(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get ad code for the specified ad unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get the code for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580318 = path.getOrDefault("adClientId")
  valid_580318 = validateParameter(valid_580318, JString, required = true,
                                 default = nil)
  if valid_580318 != nil:
    section.add "adClientId", valid_580318
  var valid_580319 = path.getOrDefault("adUnitId")
  valid_580319 = validateParameter(valid_580319, JString, required = true,
                                 default = nil)
  if valid_580319 != nil:
    section.add "adUnitId", valid_580319
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580320 = query.getOrDefault("fields")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "fields", valid_580320
  var valid_580321 = query.getOrDefault("quotaUser")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "quotaUser", valid_580321
  var valid_580322 = query.getOrDefault("alt")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = newJString("json"))
  if valid_580322 != nil:
    section.add "alt", valid_580322
  var valid_580323 = query.getOrDefault("oauth_token")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "oauth_token", valid_580323
  var valid_580324 = query.getOrDefault("userIp")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "userIp", valid_580324
  var valid_580325 = query.getOrDefault("key")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "key", valid_580325
  var valid_580326 = query.getOrDefault("prettyPrint")
  valid_580326 = validateParameter(valid_580326, JBool, required = false,
                                 default = newJBool(true))
  if valid_580326 != nil:
    section.add "prettyPrint", valid_580326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580327: Call_AdsenseAdunitsGetAdCode_580315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_580327.validator(path, query, header, formData, body)
  let scheme = call_580327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580327.url(scheme.get, call_580327.host, call_580327.base,
                         call_580327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580327, url, valid)

proc call*(call_580328: Call_AdsenseAdunitsGetAdCode_580315; adClientId: string;
          adUnitId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAdunitsGetAdCode
  ## Get ad code for the specified ad unit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580329 = newJObject()
  var query_580330 = newJObject()
  add(query_580330, "fields", newJString(fields))
  add(query_580330, "quotaUser", newJString(quotaUser))
  add(query_580330, "alt", newJString(alt))
  add(query_580330, "oauth_token", newJString(oauthToken))
  add(query_580330, "userIp", newJString(userIp))
  add(query_580330, "key", newJString(key))
  add(path_580329, "adClientId", newJString(adClientId))
  add(path_580329, "adUnitId", newJString(adUnitId))
  add(query_580330, "prettyPrint", newJBool(prettyPrint))
  result = call_580328.call(path_580329, query_580330, nil, nil, nil)

var adsenseAdunitsGetAdCode* = Call_AdsenseAdunitsGetAdCode_580315(
    name: "adsenseAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAdunitsGetAdCode_580316, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsGetAdCode_580317, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsCustomchannelsList_580331 = ref object of OpenApiRestCall_579424
proc url_AdsenseAdunitsCustomchannelsList_580333(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAdunitsCustomchannelsList_580332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit for which to list custom channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580334 = path.getOrDefault("adClientId")
  valid_580334 = validateParameter(valid_580334, JString, required = true,
                                 default = nil)
  if valid_580334 != nil:
    section.add "adClientId", valid_580334
  var valid_580335 = path.getOrDefault("adUnitId")
  valid_580335 = validateParameter(valid_580335, JString, required = true,
                                 default = nil)
  if valid_580335 != nil:
    section.add "adUnitId", valid_580335
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580336 = query.getOrDefault("fields")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "fields", valid_580336
  var valid_580337 = query.getOrDefault("pageToken")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "pageToken", valid_580337
  var valid_580338 = query.getOrDefault("quotaUser")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "quotaUser", valid_580338
  var valid_580339 = query.getOrDefault("alt")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = newJString("json"))
  if valid_580339 != nil:
    section.add "alt", valid_580339
  var valid_580340 = query.getOrDefault("oauth_token")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "oauth_token", valid_580340
  var valid_580341 = query.getOrDefault("userIp")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "userIp", valid_580341
  var valid_580342 = query.getOrDefault("maxResults")
  valid_580342 = validateParameter(valid_580342, JInt, required = false, default = nil)
  if valid_580342 != nil:
    section.add "maxResults", valid_580342
  var valid_580343 = query.getOrDefault("key")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "key", valid_580343
  var valid_580344 = query.getOrDefault("prettyPrint")
  valid_580344 = validateParameter(valid_580344, JBool, required = false,
                                 default = newJBool(true))
  if valid_580344 != nil:
    section.add "prettyPrint", valid_580344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580345: Call_AdsenseAdunitsCustomchannelsList_580331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_580345.validator(path, query, header, formData, body)
  let scheme = call_580345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580345.url(scheme.get, call_580345.host, call_580345.base,
                         call_580345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580345, url, valid)

proc call*(call_580346: Call_AdsenseAdunitsCustomchannelsList_580331;
          adClientId: string; adUnitId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAdunitsCustomchannelsList
  ## List all custom channels which the specified ad unit belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580347 = newJObject()
  var query_580348 = newJObject()
  add(query_580348, "fields", newJString(fields))
  add(query_580348, "pageToken", newJString(pageToken))
  add(query_580348, "quotaUser", newJString(quotaUser))
  add(query_580348, "alt", newJString(alt))
  add(query_580348, "oauth_token", newJString(oauthToken))
  add(query_580348, "userIp", newJString(userIp))
  add(query_580348, "maxResults", newJInt(maxResults))
  add(query_580348, "key", newJString(key))
  add(path_580347, "adClientId", newJString(adClientId))
  add(path_580347, "adUnitId", newJString(adUnitId))
  add(query_580348, "prettyPrint", newJBool(prettyPrint))
  result = call_580346.call(path_580347, query_580348, nil, nil, nil)

var adsenseAdunitsCustomchannelsList* = Call_AdsenseAdunitsCustomchannelsList_580331(
    name: "adsenseAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAdunitsCustomchannelsList_580332,
    base: "/adsense/v1.3", url: url_AdsenseAdunitsCustomchannelsList_580333,
    schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsList_580349 = ref object of OpenApiRestCall_579424
proc url_AdsenseCustomchannelsList_580351(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseCustomchannelsList_580350(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels in the specified ad client for this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580352 = path.getOrDefault("adClientId")
  valid_580352 = validateParameter(valid_580352, JString, required = true,
                                 default = nil)
  if valid_580352 != nil:
    section.add "adClientId", valid_580352
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580353 = query.getOrDefault("fields")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "fields", valid_580353
  var valid_580354 = query.getOrDefault("pageToken")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "pageToken", valid_580354
  var valid_580355 = query.getOrDefault("quotaUser")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "quotaUser", valid_580355
  var valid_580356 = query.getOrDefault("alt")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = newJString("json"))
  if valid_580356 != nil:
    section.add "alt", valid_580356
  var valid_580357 = query.getOrDefault("oauth_token")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "oauth_token", valid_580357
  var valid_580358 = query.getOrDefault("userIp")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "userIp", valid_580358
  var valid_580359 = query.getOrDefault("maxResults")
  valid_580359 = validateParameter(valid_580359, JInt, required = false, default = nil)
  if valid_580359 != nil:
    section.add "maxResults", valid_580359
  var valid_580360 = query.getOrDefault("key")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "key", valid_580360
  var valid_580361 = query.getOrDefault("prettyPrint")
  valid_580361 = validateParameter(valid_580361, JBool, required = false,
                                 default = newJBool(true))
  if valid_580361 != nil:
    section.add "prettyPrint", valid_580361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580362: Call_AdsenseCustomchannelsList_580349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_580362.validator(path, query, header, formData, body)
  let scheme = call_580362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580362.url(scheme.get, call_580362.host, call_580362.base,
                         call_580362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580362, url, valid)

proc call*(call_580363: Call_AdsenseCustomchannelsList_580349; adClientId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseCustomchannelsList
  ## List all custom channels in the specified ad client for this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580364 = newJObject()
  var query_580365 = newJObject()
  add(query_580365, "fields", newJString(fields))
  add(query_580365, "pageToken", newJString(pageToken))
  add(query_580365, "quotaUser", newJString(quotaUser))
  add(query_580365, "alt", newJString(alt))
  add(query_580365, "oauth_token", newJString(oauthToken))
  add(query_580365, "userIp", newJString(userIp))
  add(query_580365, "maxResults", newJInt(maxResults))
  add(query_580365, "key", newJString(key))
  add(path_580364, "adClientId", newJString(adClientId))
  add(query_580365, "prettyPrint", newJBool(prettyPrint))
  result = call_580363.call(path_580364, query_580365, nil, nil, nil)

var adsenseCustomchannelsList* = Call_AdsenseCustomchannelsList_580349(
    name: "adsenseCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseCustomchannelsList_580350, base: "/adsense/v1.3",
    url: url_AdsenseCustomchannelsList_580351, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsGet_580366 = ref object of OpenApiRestCall_579424
proc url_AdsenseCustomchannelsGet_580368(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "customChannelId" in path, "`customChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels/"),
               (kind: VariableSegment, value: "customChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseCustomchannelsGet_580367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customChannelId: JString (required)
  ##                  : Custom channel to retrieve.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customChannelId` field"
  var valid_580369 = path.getOrDefault("customChannelId")
  valid_580369 = validateParameter(valid_580369, JString, required = true,
                                 default = nil)
  if valid_580369 != nil:
    section.add "customChannelId", valid_580369
  var valid_580370 = path.getOrDefault("adClientId")
  valid_580370 = validateParameter(valid_580370, JString, required = true,
                                 default = nil)
  if valid_580370 != nil:
    section.add "adClientId", valid_580370
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580371 = query.getOrDefault("fields")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "fields", valid_580371
  var valid_580372 = query.getOrDefault("quotaUser")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "quotaUser", valid_580372
  var valid_580373 = query.getOrDefault("alt")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = newJString("json"))
  if valid_580373 != nil:
    section.add "alt", valid_580373
  var valid_580374 = query.getOrDefault("oauth_token")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "oauth_token", valid_580374
  var valid_580375 = query.getOrDefault("userIp")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "userIp", valid_580375
  var valid_580376 = query.getOrDefault("key")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "key", valid_580376
  var valid_580377 = query.getOrDefault("prettyPrint")
  valid_580377 = validateParameter(valid_580377, JBool, required = false,
                                 default = newJBool(true))
  if valid_580377 != nil:
    section.add "prettyPrint", valid_580377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580378: Call_AdsenseCustomchannelsGet_580366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_580378.validator(path, query, header, formData, body)
  let scheme = call_580378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580378.url(scheme.get, call_580378.host, call_580378.base,
                         call_580378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580378, url, valid)

proc call*(call_580379: Call_AdsenseCustomchannelsGet_580366;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseCustomchannelsGet
  ## Get the specified custom channel from the specified ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580380 = newJObject()
  var query_580381 = newJObject()
  add(query_580381, "fields", newJString(fields))
  add(query_580381, "quotaUser", newJString(quotaUser))
  add(query_580381, "alt", newJString(alt))
  add(query_580381, "oauth_token", newJString(oauthToken))
  add(path_580380, "customChannelId", newJString(customChannelId))
  add(query_580381, "userIp", newJString(userIp))
  add(query_580381, "key", newJString(key))
  add(path_580380, "adClientId", newJString(adClientId))
  add(query_580381, "prettyPrint", newJBool(prettyPrint))
  result = call_580379.call(path_580380, query_580381, nil, nil, nil)

var adsenseCustomchannelsGet* = Call_AdsenseCustomchannelsGet_580366(
    name: "adsenseCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseCustomchannelsGet_580367, base: "/adsense/v1.3",
    url: url_AdsenseCustomchannelsGet_580368, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsAdunitsList_580382 = ref object of OpenApiRestCall_579424
proc url_AdsenseCustomchannelsAdunitsList_580384(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "customChannelId" in path, "`customChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels/"),
               (kind: VariableSegment, value: "customChannelId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseCustomchannelsAdunitsList_580383(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified custom channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customChannelId: JString (required)
  ##                  : Custom channel for which to list ad units.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customChannelId` field"
  var valid_580385 = path.getOrDefault("customChannelId")
  valid_580385 = validateParameter(valid_580385, JString, required = true,
                                 default = nil)
  if valid_580385 != nil:
    section.add "customChannelId", valid_580385
  var valid_580386 = path.getOrDefault("adClientId")
  valid_580386 = validateParameter(valid_580386, JString, required = true,
                                 default = nil)
  if valid_580386 != nil:
    section.add "adClientId", valid_580386
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580387 = query.getOrDefault("fields")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "fields", valid_580387
  var valid_580388 = query.getOrDefault("pageToken")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "pageToken", valid_580388
  var valid_580389 = query.getOrDefault("quotaUser")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "quotaUser", valid_580389
  var valid_580390 = query.getOrDefault("alt")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = newJString("json"))
  if valid_580390 != nil:
    section.add "alt", valid_580390
  var valid_580391 = query.getOrDefault("includeInactive")
  valid_580391 = validateParameter(valid_580391, JBool, required = false, default = nil)
  if valid_580391 != nil:
    section.add "includeInactive", valid_580391
  var valid_580392 = query.getOrDefault("oauth_token")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "oauth_token", valid_580392
  var valid_580393 = query.getOrDefault("userIp")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "userIp", valid_580393
  var valid_580394 = query.getOrDefault("maxResults")
  valid_580394 = validateParameter(valid_580394, JInt, required = false, default = nil)
  if valid_580394 != nil:
    section.add "maxResults", valid_580394
  var valid_580395 = query.getOrDefault("key")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "key", valid_580395
  var valid_580396 = query.getOrDefault("prettyPrint")
  valid_580396 = validateParameter(valid_580396, JBool, required = false,
                                 default = newJBool(true))
  if valid_580396 != nil:
    section.add "prettyPrint", valid_580396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580397: Call_AdsenseCustomchannelsAdunitsList_580382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_580397.validator(path, query, header, formData, body)
  let scheme = call_580397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580397.url(scheme.get, call_580397.host, call_580397.base,
                         call_580397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580397, url, valid)

proc call*(call_580398: Call_AdsenseCustomchannelsAdunitsList_580382;
          customChannelId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          includeInactive: bool = false; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseCustomchannelsAdunitsList
  ## List all ad units in the specified custom channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel for which to list ad units.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580399 = newJObject()
  var query_580400 = newJObject()
  add(query_580400, "fields", newJString(fields))
  add(query_580400, "pageToken", newJString(pageToken))
  add(query_580400, "quotaUser", newJString(quotaUser))
  add(query_580400, "alt", newJString(alt))
  add(query_580400, "includeInactive", newJBool(includeInactive))
  add(query_580400, "oauth_token", newJString(oauthToken))
  add(path_580399, "customChannelId", newJString(customChannelId))
  add(query_580400, "userIp", newJString(userIp))
  add(query_580400, "maxResults", newJInt(maxResults))
  add(query_580400, "key", newJString(key))
  add(path_580399, "adClientId", newJString(adClientId))
  add(query_580400, "prettyPrint", newJBool(prettyPrint))
  result = call_580398.call(path_580399, query_580400, nil, nil, nil)

var adsenseCustomchannelsAdunitsList* = Call_AdsenseCustomchannelsAdunitsList_580382(
    name: "adsenseCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseCustomchannelsAdunitsList_580383,
    base: "/adsense/v1.3", url: url_AdsenseCustomchannelsAdunitsList_580384,
    schemes: {Scheme.Https})
type
  Call_AdsenseUrlchannelsList_580401 = ref object of OpenApiRestCall_579424
proc url_AdsenseUrlchannelsList_580403(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/urlchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseUrlchannelsList_580402(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all URL channels in the specified ad client for this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580404 = path.getOrDefault("adClientId")
  valid_580404 = validateParameter(valid_580404, JString, required = true,
                                 default = nil)
  if valid_580404 != nil:
    section.add "adClientId", valid_580404
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580405 = query.getOrDefault("fields")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "fields", valid_580405
  var valid_580406 = query.getOrDefault("pageToken")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "pageToken", valid_580406
  var valid_580407 = query.getOrDefault("quotaUser")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "quotaUser", valid_580407
  var valid_580408 = query.getOrDefault("alt")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = newJString("json"))
  if valid_580408 != nil:
    section.add "alt", valid_580408
  var valid_580409 = query.getOrDefault("oauth_token")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "oauth_token", valid_580409
  var valid_580410 = query.getOrDefault("userIp")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "userIp", valid_580410
  var valid_580411 = query.getOrDefault("maxResults")
  valid_580411 = validateParameter(valid_580411, JInt, required = false, default = nil)
  if valid_580411 != nil:
    section.add "maxResults", valid_580411
  var valid_580412 = query.getOrDefault("key")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "key", valid_580412
  var valid_580413 = query.getOrDefault("prettyPrint")
  valid_580413 = validateParameter(valid_580413, JBool, required = false,
                                 default = newJBool(true))
  if valid_580413 != nil:
    section.add "prettyPrint", valid_580413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580414: Call_AdsenseUrlchannelsList_580401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_580414.validator(path, query, header, formData, body)
  let scheme = call_580414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580414.url(scheme.get, call_580414.host, call_580414.base,
                         call_580414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580414, url, valid)

proc call*(call_580415: Call_AdsenseUrlchannelsList_580401; adClientId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseUrlchannelsList
  ## List all URL channels in the specified ad client for this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580416 = newJObject()
  var query_580417 = newJObject()
  add(query_580417, "fields", newJString(fields))
  add(query_580417, "pageToken", newJString(pageToken))
  add(query_580417, "quotaUser", newJString(quotaUser))
  add(query_580417, "alt", newJString(alt))
  add(query_580417, "oauth_token", newJString(oauthToken))
  add(query_580417, "userIp", newJString(userIp))
  add(query_580417, "maxResults", newJInt(maxResults))
  add(query_580417, "key", newJString(key))
  add(path_580416, "adClientId", newJString(adClientId))
  add(query_580417, "prettyPrint", newJBool(prettyPrint))
  result = call_580415.call(path_580416, query_580417, nil, nil, nil)

var adsenseUrlchannelsList* = Call_AdsenseUrlchannelsList_580401(
    name: "adsenseUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseUrlchannelsList_580402, base: "/adsense/v1.3",
    url: url_AdsenseUrlchannelsList_580403, schemes: {Scheme.Https})
type
  Call_AdsenseAlertsList_580418 = ref object of OpenApiRestCall_579424
proc url_AdsenseAlertsList_580420(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAlertsList_580419(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List the alerts for this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580421 = query.getOrDefault("locale")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "locale", valid_580421
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
  var valid_580426 = query.getOrDefault("userIp")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "userIp", valid_580426
  var valid_580427 = query.getOrDefault("key")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "key", valid_580427
  var valid_580428 = query.getOrDefault("prettyPrint")
  valid_580428 = validateParameter(valid_580428, JBool, required = false,
                                 default = newJBool(true))
  if valid_580428 != nil:
    section.add "prettyPrint", valid_580428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580429: Call_AdsenseAlertsList_580418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for this AdSense account.
  ## 
  let valid = call_580429.validator(path, query, header, formData, body)
  let scheme = call_580429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580429.url(scheme.get, call_580429.host, call_580429.base,
                         call_580429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580429, url, valid)

proc call*(call_580430: Call_AdsenseAlertsList_580418; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAlertsList
  ## List the alerts for this AdSense account.
  ##   locale: string
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580431 = newJObject()
  add(query_580431, "locale", newJString(locale))
  add(query_580431, "fields", newJString(fields))
  add(query_580431, "quotaUser", newJString(quotaUser))
  add(query_580431, "alt", newJString(alt))
  add(query_580431, "oauth_token", newJString(oauthToken))
  add(query_580431, "userIp", newJString(userIp))
  add(query_580431, "key", newJString(key))
  add(query_580431, "prettyPrint", newJBool(prettyPrint))
  result = call_580430.call(nil, query_580431, nil, nil, nil)

var adsenseAlertsList* = Call_AdsenseAlertsList_580418(name: "adsenseAlertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/alerts",
    validator: validate_AdsenseAlertsList_580419, base: "/adsense/v1.3",
    url: url_AdsenseAlertsList_580420, schemes: {Scheme.Https})
type
  Call_AdsenseMetadataDimensionsList_580432 = ref object of OpenApiRestCall_579424
proc url_AdsenseMetadataDimensionsList_580434(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseMetadataDimensionsList_580433(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the dimensions available to this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580435 = query.getOrDefault("fields")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "fields", valid_580435
  var valid_580436 = query.getOrDefault("quotaUser")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "quotaUser", valid_580436
  var valid_580437 = query.getOrDefault("alt")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = newJString("json"))
  if valid_580437 != nil:
    section.add "alt", valid_580437
  var valid_580438 = query.getOrDefault("oauth_token")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "oauth_token", valid_580438
  var valid_580439 = query.getOrDefault("userIp")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "userIp", valid_580439
  var valid_580440 = query.getOrDefault("key")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "key", valid_580440
  var valid_580441 = query.getOrDefault("prettyPrint")
  valid_580441 = validateParameter(valid_580441, JBool, required = false,
                                 default = newJBool(true))
  if valid_580441 != nil:
    section.add "prettyPrint", valid_580441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580442: Call_AdsenseMetadataDimensionsList_580432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdSense account.
  ## 
  let valid = call_580442.validator(path, query, header, formData, body)
  let scheme = call_580442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580442.url(scheme.get, call_580442.host, call_580442.base,
                         call_580442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580442, url, valid)

proc call*(call_580443: Call_AdsenseMetadataDimensionsList_580432;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseMetadataDimensionsList
  ## List the metadata for the dimensions available to this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580444 = newJObject()
  add(query_580444, "fields", newJString(fields))
  add(query_580444, "quotaUser", newJString(quotaUser))
  add(query_580444, "alt", newJString(alt))
  add(query_580444, "oauth_token", newJString(oauthToken))
  add(query_580444, "userIp", newJString(userIp))
  add(query_580444, "key", newJString(key))
  add(query_580444, "prettyPrint", newJBool(prettyPrint))
  result = call_580443.call(nil, query_580444, nil, nil, nil)

var adsenseMetadataDimensionsList* = Call_AdsenseMetadataDimensionsList_580432(
    name: "adsenseMetadataDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/dimensions",
    validator: validate_AdsenseMetadataDimensionsList_580433,
    base: "/adsense/v1.3", url: url_AdsenseMetadataDimensionsList_580434,
    schemes: {Scheme.Https})
type
  Call_AdsenseMetadataMetricsList_580445 = ref object of OpenApiRestCall_579424
proc url_AdsenseMetadataMetricsList_580447(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseMetadataMetricsList_580446(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the metrics available to this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580448 = query.getOrDefault("fields")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "fields", valid_580448
  var valid_580449 = query.getOrDefault("quotaUser")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "quotaUser", valid_580449
  var valid_580450 = query.getOrDefault("alt")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = newJString("json"))
  if valid_580450 != nil:
    section.add "alt", valid_580450
  var valid_580451 = query.getOrDefault("oauth_token")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "oauth_token", valid_580451
  var valid_580452 = query.getOrDefault("userIp")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "userIp", valid_580452
  var valid_580453 = query.getOrDefault("key")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "key", valid_580453
  var valid_580454 = query.getOrDefault("prettyPrint")
  valid_580454 = validateParameter(valid_580454, JBool, required = false,
                                 default = newJBool(true))
  if valid_580454 != nil:
    section.add "prettyPrint", valid_580454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580455: Call_AdsenseMetadataMetricsList_580445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdSense account.
  ## 
  let valid = call_580455.validator(path, query, header, formData, body)
  let scheme = call_580455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580455.url(scheme.get, call_580455.host, call_580455.base,
                         call_580455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580455, url, valid)

proc call*(call_580456: Call_AdsenseMetadataMetricsList_580445;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseMetadataMetricsList
  ## List the metadata for the metrics available to this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580457 = newJObject()
  add(query_580457, "fields", newJString(fields))
  add(query_580457, "quotaUser", newJString(quotaUser))
  add(query_580457, "alt", newJString(alt))
  add(query_580457, "oauth_token", newJString(oauthToken))
  add(query_580457, "userIp", newJString(userIp))
  add(query_580457, "key", newJString(key))
  add(query_580457, "prettyPrint", newJBool(prettyPrint))
  result = call_580456.call(nil, query_580457, nil, nil, nil)

var adsenseMetadataMetricsList* = Call_AdsenseMetadataMetricsList_580445(
    name: "adsenseMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/metrics",
    validator: validate_AdsenseMetadataMetricsList_580446, base: "/adsense/v1.3",
    url: url_AdsenseMetadataMetricsList_580447, schemes: {Scheme.Https})
type
  Call_AdsenseReportsGenerate_580458 = ref object of OpenApiRestCall_579424
proc url_AdsenseReportsGenerate_580460(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseReportsGenerate_580459(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   useTimezoneReporting: JBool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   currency: JString
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   accountId: JArray
  ##            : Accounts upon which to report.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_580461 = query.getOrDefault("useTimezoneReporting")
  valid_580461 = validateParameter(valid_580461, JBool, required = false, default = nil)
  if valid_580461 != nil:
    section.add "useTimezoneReporting", valid_580461
  var valid_580462 = query.getOrDefault("locale")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "locale", valid_580462
  var valid_580463 = query.getOrDefault("fields")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "fields", valid_580463
  var valid_580464 = query.getOrDefault("quotaUser")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "quotaUser", valid_580464
  var valid_580465 = query.getOrDefault("alt")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = newJString("json"))
  if valid_580465 != nil:
    section.add "alt", valid_580465
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_580466 = query.getOrDefault("endDate")
  valid_580466 = validateParameter(valid_580466, JString, required = true,
                                 default = nil)
  if valid_580466 != nil:
    section.add "endDate", valid_580466
  var valid_580467 = query.getOrDefault("currency")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "currency", valid_580467
  var valid_580468 = query.getOrDefault("startDate")
  valid_580468 = validateParameter(valid_580468, JString, required = true,
                                 default = nil)
  if valid_580468 != nil:
    section.add "startDate", valid_580468
  var valid_580469 = query.getOrDefault("sort")
  valid_580469 = validateParameter(valid_580469, JArray, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "sort", valid_580469
  var valid_580470 = query.getOrDefault("oauth_token")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "oauth_token", valid_580470
  var valid_580471 = query.getOrDefault("accountId")
  valid_580471 = validateParameter(valid_580471, JArray, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "accountId", valid_580471
  var valid_580472 = query.getOrDefault("userIp")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "userIp", valid_580472
  var valid_580473 = query.getOrDefault("maxResults")
  valid_580473 = validateParameter(valid_580473, JInt, required = false, default = nil)
  if valid_580473 != nil:
    section.add "maxResults", valid_580473
  var valid_580474 = query.getOrDefault("key")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "key", valid_580474
  var valid_580475 = query.getOrDefault("metric")
  valid_580475 = validateParameter(valid_580475, JArray, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "metric", valid_580475
  var valid_580476 = query.getOrDefault("prettyPrint")
  valid_580476 = validateParameter(valid_580476, JBool, required = false,
                                 default = newJBool(true))
  if valid_580476 != nil:
    section.add "prettyPrint", valid_580476
  var valid_580477 = query.getOrDefault("dimension")
  valid_580477 = validateParameter(valid_580477, JArray, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "dimension", valid_580477
  var valid_580478 = query.getOrDefault("filter")
  valid_580478 = validateParameter(valid_580478, JArray, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "filter", valid_580478
  var valid_580479 = query.getOrDefault("startIndex")
  valid_580479 = validateParameter(valid_580479, JInt, required = false, default = nil)
  if valid_580479 != nil:
    section.add "startIndex", valid_580479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580480: Call_AdsenseReportsGenerate_580458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_580480.validator(path, query, header, formData, body)
  let scheme = call_580480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580480.url(scheme.get, call_580480.host, call_580480.base,
                         call_580480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580480, url, valid)

proc call*(call_580481: Call_AdsenseReportsGenerate_580458; endDate: string;
          startDate: string; useTimezoneReporting: bool = false; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          currency: string = ""; sort: JsonNode = nil; oauthToken: string = "";
          accountId: JsonNode = nil; userIp: string = ""; maxResults: int = 0;
          key: string = ""; metric: JsonNode = nil; prettyPrint: bool = true;
          dimension: JsonNode = nil; filter: JsonNode = nil; startIndex: int = 0): Recallable =
  ## adsenseReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   useTimezoneReporting: bool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   currency: string
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: JArray
  ##            : Accounts upon which to report.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var query_580482 = newJObject()
  add(query_580482, "useTimezoneReporting", newJBool(useTimezoneReporting))
  add(query_580482, "locale", newJString(locale))
  add(query_580482, "fields", newJString(fields))
  add(query_580482, "quotaUser", newJString(quotaUser))
  add(query_580482, "alt", newJString(alt))
  add(query_580482, "endDate", newJString(endDate))
  add(query_580482, "currency", newJString(currency))
  add(query_580482, "startDate", newJString(startDate))
  if sort != nil:
    query_580482.add "sort", sort
  add(query_580482, "oauth_token", newJString(oauthToken))
  if accountId != nil:
    query_580482.add "accountId", accountId
  add(query_580482, "userIp", newJString(userIp))
  add(query_580482, "maxResults", newJInt(maxResults))
  add(query_580482, "key", newJString(key))
  if metric != nil:
    query_580482.add "metric", metric
  add(query_580482, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_580482.add "dimension", dimension
  if filter != nil:
    query_580482.add "filter", filter
  add(query_580482, "startIndex", newJInt(startIndex))
  result = call_580481.call(nil, query_580482, nil, nil, nil)

var adsenseReportsGenerate* = Call_AdsenseReportsGenerate_580458(
    name: "adsenseReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsenseReportsGenerate_580459, base: "/adsense/v1.3",
    url: url_AdsenseReportsGenerate_580460, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedList_580483 = ref object of OpenApiRestCall_579424
proc url_AdsenseReportsSavedList_580485(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseReportsSavedList_580484(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580486 = query.getOrDefault("fields")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "fields", valid_580486
  var valid_580487 = query.getOrDefault("pageToken")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "pageToken", valid_580487
  var valid_580488 = query.getOrDefault("quotaUser")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "quotaUser", valid_580488
  var valid_580489 = query.getOrDefault("alt")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = newJString("json"))
  if valid_580489 != nil:
    section.add "alt", valid_580489
  var valid_580490 = query.getOrDefault("oauth_token")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "oauth_token", valid_580490
  var valid_580491 = query.getOrDefault("userIp")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "userIp", valid_580491
  var valid_580492 = query.getOrDefault("maxResults")
  valid_580492 = validateParameter(valid_580492, JInt, required = false, default = nil)
  if valid_580492 != nil:
    section.add "maxResults", valid_580492
  var valid_580493 = query.getOrDefault("key")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "key", valid_580493
  var valid_580494 = query.getOrDefault("prettyPrint")
  valid_580494 = validateParameter(valid_580494, JBool, required = false,
                                 default = newJBool(true))
  if valid_580494 != nil:
    section.add "prettyPrint", valid_580494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580495: Call_AdsenseReportsSavedList_580483; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved reports in this AdSense account.
  ## 
  let valid = call_580495.validator(path, query, header, formData, body)
  let scheme = call_580495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580495.url(scheme.get, call_580495.host, call_580495.base,
                         call_580495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580495, url, valid)

proc call*(call_580496: Call_AdsenseReportsSavedList_580483; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseReportsSavedList
  ## List all saved reports in this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580497 = newJObject()
  add(query_580497, "fields", newJString(fields))
  add(query_580497, "pageToken", newJString(pageToken))
  add(query_580497, "quotaUser", newJString(quotaUser))
  add(query_580497, "alt", newJString(alt))
  add(query_580497, "oauth_token", newJString(oauthToken))
  add(query_580497, "userIp", newJString(userIp))
  add(query_580497, "maxResults", newJInt(maxResults))
  add(query_580497, "key", newJString(key))
  add(query_580497, "prettyPrint", newJBool(prettyPrint))
  result = call_580496.call(nil, query_580497, nil, nil, nil)

var adsenseReportsSavedList* = Call_AdsenseReportsSavedList_580483(
    name: "adsenseReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdsenseReportsSavedList_580484, base: "/adsense/v1.3",
    url: url_AdsenseReportsSavedList_580485, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedGenerate_580498 = ref object of OpenApiRestCall_579424
proc url_AdsenseReportsSavedGenerate_580500(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "savedReportId" in path, "`savedReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "savedReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseReportsSavedGenerate_580499(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedReportId: JString (required)
  ##                : The saved report to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedReportId` field"
  var valid_580501 = path.getOrDefault("savedReportId")
  valid_580501 = validateParameter(valid_580501, JString, required = true,
                                 default = nil)
  if valid_580501 != nil:
    section.add "savedReportId", valid_580501
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_580502 = query.getOrDefault("locale")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "locale", valid_580502
  var valid_580503 = query.getOrDefault("fields")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "fields", valid_580503
  var valid_580504 = query.getOrDefault("quotaUser")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "quotaUser", valid_580504
  var valid_580505 = query.getOrDefault("alt")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = newJString("json"))
  if valid_580505 != nil:
    section.add "alt", valid_580505
  var valid_580506 = query.getOrDefault("oauth_token")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "oauth_token", valid_580506
  var valid_580507 = query.getOrDefault("userIp")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "userIp", valid_580507
  var valid_580508 = query.getOrDefault("maxResults")
  valid_580508 = validateParameter(valid_580508, JInt, required = false, default = nil)
  if valid_580508 != nil:
    section.add "maxResults", valid_580508
  var valid_580509 = query.getOrDefault("key")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "key", valid_580509
  var valid_580510 = query.getOrDefault("prettyPrint")
  valid_580510 = validateParameter(valid_580510, JBool, required = false,
                                 default = newJBool(true))
  if valid_580510 != nil:
    section.add "prettyPrint", valid_580510
  var valid_580511 = query.getOrDefault("startIndex")
  valid_580511 = validateParameter(valid_580511, JInt, required = false, default = nil)
  if valid_580511 != nil:
    section.add "startIndex", valid_580511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580512: Call_AdsenseReportsSavedGenerate_580498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_580512.validator(path, query, header, formData, body)
  let scheme = call_580512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580512.url(scheme.get, call_580512.host, call_580512.base,
                         call_580512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580512, url, valid)

proc call*(call_580513: Call_AdsenseReportsSavedGenerate_580498;
          savedReportId: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## adsenseReportsSavedGenerate
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var path_580514 = newJObject()
  var query_580515 = newJObject()
  add(query_580515, "locale", newJString(locale))
  add(query_580515, "fields", newJString(fields))
  add(query_580515, "quotaUser", newJString(quotaUser))
  add(query_580515, "alt", newJString(alt))
  add(query_580515, "oauth_token", newJString(oauthToken))
  add(query_580515, "userIp", newJString(userIp))
  add(path_580514, "savedReportId", newJString(savedReportId))
  add(query_580515, "maxResults", newJInt(maxResults))
  add(query_580515, "key", newJString(key))
  add(query_580515, "prettyPrint", newJBool(prettyPrint))
  add(query_580515, "startIndex", newJInt(startIndex))
  result = call_580513.call(path_580514, query_580515, nil, nil, nil)

var adsenseReportsSavedGenerate* = Call_AdsenseReportsSavedGenerate_580498(
    name: "adsenseReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdsenseReportsSavedGenerate_580499, base: "/adsense/v1.3",
    url: url_AdsenseReportsSavedGenerate_580500, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesList_580516 = ref object of OpenApiRestCall_579424
proc url_AdsenseSavedadstylesList_580518(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseSavedadstylesList_580517(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved ad styles in the user's account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580519 = query.getOrDefault("fields")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "fields", valid_580519
  var valid_580520 = query.getOrDefault("pageToken")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "pageToken", valid_580520
  var valid_580521 = query.getOrDefault("quotaUser")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "quotaUser", valid_580521
  var valid_580522 = query.getOrDefault("alt")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = newJString("json"))
  if valid_580522 != nil:
    section.add "alt", valid_580522
  var valid_580523 = query.getOrDefault("oauth_token")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "oauth_token", valid_580523
  var valid_580524 = query.getOrDefault("userIp")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "userIp", valid_580524
  var valid_580525 = query.getOrDefault("maxResults")
  valid_580525 = validateParameter(valid_580525, JInt, required = false, default = nil)
  if valid_580525 != nil:
    section.add "maxResults", valid_580525
  var valid_580526 = query.getOrDefault("key")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "key", valid_580526
  var valid_580527 = query.getOrDefault("prettyPrint")
  valid_580527 = validateParameter(valid_580527, JBool, required = false,
                                 default = newJBool(true))
  if valid_580527 != nil:
    section.add "prettyPrint", valid_580527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580528: Call_AdsenseSavedadstylesList_580516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved ad styles in the user's account.
  ## 
  let valid = call_580528.validator(path, query, header, formData, body)
  let scheme = call_580528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580528.url(scheme.get, call_580528.host, call_580528.base,
                         call_580528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580528, url, valid)

proc call*(call_580529: Call_AdsenseSavedadstylesList_580516; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseSavedadstylesList
  ## List all saved ad styles in the user's account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580530 = newJObject()
  add(query_580530, "fields", newJString(fields))
  add(query_580530, "pageToken", newJString(pageToken))
  add(query_580530, "quotaUser", newJString(quotaUser))
  add(query_580530, "alt", newJString(alt))
  add(query_580530, "oauth_token", newJString(oauthToken))
  add(query_580530, "userIp", newJString(userIp))
  add(query_580530, "maxResults", newJInt(maxResults))
  add(query_580530, "key", newJString(key))
  add(query_580530, "prettyPrint", newJBool(prettyPrint))
  result = call_580529.call(nil, query_580530, nil, nil, nil)

var adsenseSavedadstylesList* = Call_AdsenseSavedadstylesList_580516(
    name: "adsenseSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles",
    validator: validate_AdsenseSavedadstylesList_580517, base: "/adsense/v1.3",
    url: url_AdsenseSavedadstylesList_580518, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesGet_580531 = ref object of OpenApiRestCall_579424
proc url_AdsenseSavedadstylesGet_580533(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "savedAdStyleId" in path, "`savedAdStyleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/savedadstyles/"),
               (kind: VariableSegment, value: "savedAdStyleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseSavedadstylesGet_580532(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific saved ad style from the user's account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedAdStyleId: JString (required)
  ##                 : Saved ad style to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedAdStyleId` field"
  var valid_580534 = path.getOrDefault("savedAdStyleId")
  valid_580534 = validateParameter(valid_580534, JString, required = true,
                                 default = nil)
  if valid_580534 != nil:
    section.add "savedAdStyleId", valid_580534
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580535 = query.getOrDefault("fields")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "fields", valid_580535
  var valid_580536 = query.getOrDefault("quotaUser")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "quotaUser", valid_580536
  var valid_580537 = query.getOrDefault("alt")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = newJString("json"))
  if valid_580537 != nil:
    section.add "alt", valid_580537
  var valid_580538 = query.getOrDefault("oauth_token")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "oauth_token", valid_580538
  var valid_580539 = query.getOrDefault("userIp")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "userIp", valid_580539
  var valid_580540 = query.getOrDefault("key")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "key", valid_580540
  var valid_580541 = query.getOrDefault("prettyPrint")
  valid_580541 = validateParameter(valid_580541, JBool, required = false,
                                 default = newJBool(true))
  if valid_580541 != nil:
    section.add "prettyPrint", valid_580541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580542: Call_AdsenseSavedadstylesGet_580531; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific saved ad style from the user's account.
  ## 
  let valid = call_580542.validator(path, query, header, formData, body)
  let scheme = call_580542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580542.url(scheme.get, call_580542.host, call_580542.base,
                         call_580542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580542, url, valid)

proc call*(call_580543: Call_AdsenseSavedadstylesGet_580531;
          savedAdStyleId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseSavedadstylesGet
  ## Get a specific saved ad style from the user's account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   savedAdStyleId: string (required)
  ##                 : Saved ad style to retrieve.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580544 = newJObject()
  var query_580545 = newJObject()
  add(query_580545, "fields", newJString(fields))
  add(query_580545, "quotaUser", newJString(quotaUser))
  add(query_580545, "alt", newJString(alt))
  add(query_580545, "oauth_token", newJString(oauthToken))
  add(path_580544, "savedAdStyleId", newJString(savedAdStyleId))
  add(query_580545, "userIp", newJString(userIp))
  add(query_580545, "key", newJString(key))
  add(query_580545, "prettyPrint", newJBool(prettyPrint))
  result = call_580543.call(path_580544, query_580545, nil, nil, nil)

var adsenseSavedadstylesGet* = Call_AdsenseSavedadstylesGet_580531(
    name: "adsenseSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseSavedadstylesGet_580532, base: "/adsense/v1.3",
    url: url_AdsenseSavedadstylesGet_580533, schemes: {Scheme.Https})
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
