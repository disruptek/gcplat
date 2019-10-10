
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
  gcpServiceName = "adsense"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdsenseAccountsList_588726 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsList_588728(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAccountsList_588727(path: JsonNode; query: JsonNode;
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
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("pageToken")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "pageToken", valid_588841
  var valid_588842 = query.getOrDefault("quotaUser")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "quotaUser", valid_588842
  var valid_588856 = query.getOrDefault("alt")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = newJString("json"))
  if valid_588856 != nil:
    section.add "alt", valid_588856
  var valid_588857 = query.getOrDefault("oauth_token")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "oauth_token", valid_588857
  var valid_588858 = query.getOrDefault("userIp")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "userIp", valid_588858
  var valid_588859 = query.getOrDefault("maxResults")
  valid_588859 = validateParameter(valid_588859, JInt, required = false, default = nil)
  if valid_588859 != nil:
    section.add "maxResults", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("prettyPrint")
  valid_588861 = validateParameter(valid_588861, JBool, required = false,
                                 default = newJBool(true))
  if valid_588861 != nil:
    section.add "prettyPrint", valid_588861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588884: Call_AdsenseAccountsList_588726; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accounts available to this AdSense account.
  ## 
  let valid = call_588884.validator(path, query, header, formData, body)
  let scheme = call_588884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588884.url(scheme.get, call_588884.host, call_588884.base,
                         call_588884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588884, url, valid)

proc call*(call_588955: Call_AdsenseAccountsList_588726; fields: string = "";
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
  var query_588956 = newJObject()
  add(query_588956, "fields", newJString(fields))
  add(query_588956, "pageToken", newJString(pageToken))
  add(query_588956, "quotaUser", newJString(quotaUser))
  add(query_588956, "alt", newJString(alt))
  add(query_588956, "oauth_token", newJString(oauthToken))
  add(query_588956, "userIp", newJString(userIp))
  add(query_588956, "maxResults", newJInt(maxResults))
  add(query_588956, "key", newJString(key))
  add(query_588956, "prettyPrint", newJBool(prettyPrint))
  result = call_588955.call(nil, query_588956, nil, nil, nil)

var adsenseAccountsList* = Call_AdsenseAccountsList_588726(
    name: "adsenseAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdsenseAccountsList_588727, base: "/adsense/v1.3",
    url: url_AdsenseAccountsList_588728, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsGet_588996 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsGet_588998(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAccountsGet_588997(path: JsonNode; query: JsonNode;
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
  var valid_589013 = path.getOrDefault("accountId")
  valid_589013 = validateParameter(valid_589013, JString, required = true,
                                 default = nil)
  if valid_589013 != nil:
    section.add "accountId", valid_589013
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
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("json"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("oauth_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "oauth_token", valid_589017
  var valid_589018 = query.getOrDefault("userIp")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "userIp", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("tree")
  valid_589020 = validateParameter(valid_589020, JBool, required = false, default = nil)
  if valid_589020 != nil:
    section.add "tree", valid_589020
  var valid_589021 = query.getOrDefault("prettyPrint")
  valid_589021 = validateParameter(valid_589021, JBool, required = false,
                                 default = newJBool(true))
  if valid_589021 != nil:
    section.add "prettyPrint", valid_589021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589022: Call_AdsenseAccountsGet_588996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected AdSense account.
  ## 
  let valid = call_589022.validator(path, query, header, formData, body)
  let scheme = call_589022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589022.url(scheme.get, call_589022.host, call_589022.base,
                         call_589022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589022, url, valid)

proc call*(call_589023: Call_AdsenseAccountsGet_588996; accountId: string;
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
  var path_589024 = newJObject()
  var query_589025 = newJObject()
  add(query_589025, "fields", newJString(fields))
  add(query_589025, "quotaUser", newJString(quotaUser))
  add(query_589025, "alt", newJString(alt))
  add(query_589025, "oauth_token", newJString(oauthToken))
  add(path_589024, "accountId", newJString(accountId))
  add(query_589025, "userIp", newJString(userIp))
  add(query_589025, "key", newJString(key))
  add(query_589025, "tree", newJBool(tree))
  add(query_589025, "prettyPrint", newJBool(prettyPrint))
  result = call_589023.call(path_589024, query_589025, nil, nil, nil)

var adsenseAccountsGet* = Call_AdsenseAccountsGet_588996(
    name: "adsenseAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdsenseAccountsGet_588997, base: "/adsense/v1.3",
    url: url_AdsenseAccountsGet_588998, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdclientsList_589026 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsAdclientsList_589028(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdclientsList_589027(path: JsonNode; query: JsonNode;
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
  var valid_589029 = path.getOrDefault("accountId")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "accountId", valid_589029
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
  var valid_589030 = query.getOrDefault("fields")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "fields", valid_589030
  var valid_589031 = query.getOrDefault("pageToken")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "pageToken", valid_589031
  var valid_589032 = query.getOrDefault("quotaUser")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "quotaUser", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("userIp")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "userIp", valid_589035
  var valid_589036 = query.getOrDefault("maxResults")
  valid_589036 = validateParameter(valid_589036, JInt, required = false, default = nil)
  if valid_589036 != nil:
    section.add "maxResults", valid_589036
  var valid_589037 = query.getOrDefault("key")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "key", valid_589037
  var valid_589038 = query.getOrDefault("prettyPrint")
  valid_589038 = validateParameter(valid_589038, JBool, required = false,
                                 default = newJBool(true))
  if valid_589038 != nil:
    section.add "prettyPrint", valid_589038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589039: Call_AdsenseAccountsAdclientsList_589026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in the specified account.
  ## 
  let valid = call_589039.validator(path, query, header, formData, body)
  let scheme = call_589039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589039.url(scheme.get, call_589039.host, call_589039.base,
                         call_589039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589039, url, valid)

proc call*(call_589040: Call_AdsenseAccountsAdclientsList_589026;
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
  var path_589041 = newJObject()
  var query_589042 = newJObject()
  add(query_589042, "fields", newJString(fields))
  add(query_589042, "pageToken", newJString(pageToken))
  add(query_589042, "quotaUser", newJString(quotaUser))
  add(query_589042, "alt", newJString(alt))
  add(query_589042, "oauth_token", newJString(oauthToken))
  add(path_589041, "accountId", newJString(accountId))
  add(query_589042, "userIp", newJString(userIp))
  add(query_589042, "maxResults", newJInt(maxResults))
  add(query_589042, "key", newJString(key))
  add(query_589042, "prettyPrint", newJBool(prettyPrint))
  result = call_589040.call(path_589041, query_589042, nil, nil, nil)

var adsenseAccountsAdclientsList* = Call_AdsenseAccountsAdclientsList_589026(
    name: "adsenseAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdsenseAccountsAdclientsList_589027,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdclientsList_589028,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsList_589043 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsAdunitsList_589045(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsList_589044(path: JsonNode; query: JsonNode;
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
  var valid_589046 = path.getOrDefault("accountId")
  valid_589046 = validateParameter(valid_589046, JString, required = true,
                                 default = nil)
  if valid_589046 != nil:
    section.add "accountId", valid_589046
  var valid_589047 = path.getOrDefault("adClientId")
  valid_589047 = validateParameter(valid_589047, JString, required = true,
                                 default = nil)
  if valid_589047 != nil:
    section.add "adClientId", valid_589047
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
  var valid_589048 = query.getOrDefault("fields")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "fields", valid_589048
  var valid_589049 = query.getOrDefault("pageToken")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "pageToken", valid_589049
  var valid_589050 = query.getOrDefault("quotaUser")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "quotaUser", valid_589050
  var valid_589051 = query.getOrDefault("alt")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = newJString("json"))
  if valid_589051 != nil:
    section.add "alt", valid_589051
  var valid_589052 = query.getOrDefault("includeInactive")
  valid_589052 = validateParameter(valid_589052, JBool, required = false, default = nil)
  if valid_589052 != nil:
    section.add "includeInactive", valid_589052
  var valid_589053 = query.getOrDefault("oauth_token")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "oauth_token", valid_589053
  var valid_589054 = query.getOrDefault("userIp")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "userIp", valid_589054
  var valid_589055 = query.getOrDefault("maxResults")
  valid_589055 = validateParameter(valid_589055, JInt, required = false, default = nil)
  if valid_589055 != nil:
    section.add "maxResults", valid_589055
  var valid_589056 = query.getOrDefault("key")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "key", valid_589056
  var valid_589057 = query.getOrDefault("prettyPrint")
  valid_589057 = validateParameter(valid_589057, JBool, required = false,
                                 default = newJBool(true))
  if valid_589057 != nil:
    section.add "prettyPrint", valid_589057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589058: Call_AdsenseAccountsAdunitsList_589043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for the specified account.
  ## 
  let valid = call_589058.validator(path, query, header, formData, body)
  let scheme = call_589058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589058.url(scheme.get, call_589058.host, call_589058.base,
                         call_589058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589058, url, valid)

proc call*(call_589059: Call_AdsenseAccountsAdunitsList_589043; accountId: string;
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
  var path_589060 = newJObject()
  var query_589061 = newJObject()
  add(query_589061, "fields", newJString(fields))
  add(query_589061, "pageToken", newJString(pageToken))
  add(query_589061, "quotaUser", newJString(quotaUser))
  add(query_589061, "alt", newJString(alt))
  add(query_589061, "includeInactive", newJBool(includeInactive))
  add(query_589061, "oauth_token", newJString(oauthToken))
  add(path_589060, "accountId", newJString(accountId))
  add(query_589061, "userIp", newJString(userIp))
  add(query_589061, "maxResults", newJInt(maxResults))
  add(query_589061, "key", newJString(key))
  add(path_589060, "adClientId", newJString(adClientId))
  add(query_589061, "prettyPrint", newJBool(prettyPrint))
  result = call_589059.call(path_589060, query_589061, nil, nil, nil)

var adsenseAccountsAdunitsList* = Call_AdsenseAccountsAdunitsList_589043(
    name: "adsenseAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAccountsAdunitsList_589044, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAdunitsList_589045, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGet_589062 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsAdunitsGet_589064(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsGet_589063(path: JsonNode; query: JsonNode;
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
  var valid_589065 = path.getOrDefault("accountId")
  valid_589065 = validateParameter(valid_589065, JString, required = true,
                                 default = nil)
  if valid_589065 != nil:
    section.add "accountId", valid_589065
  var valid_589066 = path.getOrDefault("adClientId")
  valid_589066 = validateParameter(valid_589066, JString, required = true,
                                 default = nil)
  if valid_589066 != nil:
    section.add "adClientId", valid_589066
  var valid_589067 = path.getOrDefault("adUnitId")
  valid_589067 = validateParameter(valid_589067, JString, required = true,
                                 default = nil)
  if valid_589067 != nil:
    section.add "adUnitId", valid_589067
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
  var valid_589068 = query.getOrDefault("fields")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "fields", valid_589068
  var valid_589069 = query.getOrDefault("quotaUser")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "quotaUser", valid_589069
  var valid_589070 = query.getOrDefault("alt")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = newJString("json"))
  if valid_589070 != nil:
    section.add "alt", valid_589070
  var valid_589071 = query.getOrDefault("oauth_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "oauth_token", valid_589071
  var valid_589072 = query.getOrDefault("userIp")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "userIp", valid_589072
  var valid_589073 = query.getOrDefault("key")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "key", valid_589073
  var valid_589074 = query.getOrDefault("prettyPrint")
  valid_589074 = validateParameter(valid_589074, JBool, required = false,
                                 default = newJBool(true))
  if valid_589074 != nil:
    section.add "prettyPrint", valid_589074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589075: Call_AdsenseAccountsAdunitsGet_589062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ## 
  let valid = call_589075.validator(path, query, header, formData, body)
  let scheme = call_589075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589075.url(scheme.get, call_589075.host, call_589075.base,
                         call_589075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589075, url, valid)

proc call*(call_589076: Call_AdsenseAccountsAdunitsGet_589062; accountId: string;
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
  var path_589077 = newJObject()
  var query_589078 = newJObject()
  add(query_589078, "fields", newJString(fields))
  add(query_589078, "quotaUser", newJString(quotaUser))
  add(query_589078, "alt", newJString(alt))
  add(query_589078, "oauth_token", newJString(oauthToken))
  add(path_589077, "accountId", newJString(accountId))
  add(query_589078, "userIp", newJString(userIp))
  add(query_589078, "key", newJString(key))
  add(path_589077, "adClientId", newJString(adClientId))
  add(path_589077, "adUnitId", newJString(adUnitId))
  add(query_589078, "prettyPrint", newJBool(prettyPrint))
  result = call_589076.call(path_589077, query_589078, nil, nil, nil)

var adsenseAccountsAdunitsGet* = Call_AdsenseAccountsAdunitsGet_589062(
    name: "adsenseAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAccountsAdunitsGet_589063, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAdunitsGet_589064, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGetAdCode_589079 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsAdunitsGetAdCode_589081(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsGetAdCode_589080(path: JsonNode;
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
  var valid_589082 = path.getOrDefault("accountId")
  valid_589082 = validateParameter(valid_589082, JString, required = true,
                                 default = nil)
  if valid_589082 != nil:
    section.add "accountId", valid_589082
  var valid_589083 = path.getOrDefault("adClientId")
  valid_589083 = validateParameter(valid_589083, JString, required = true,
                                 default = nil)
  if valid_589083 != nil:
    section.add "adClientId", valid_589083
  var valid_589084 = path.getOrDefault("adUnitId")
  valid_589084 = validateParameter(valid_589084, JString, required = true,
                                 default = nil)
  if valid_589084 != nil:
    section.add "adUnitId", valid_589084
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
  var valid_589085 = query.getOrDefault("fields")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "fields", valid_589085
  var valid_589086 = query.getOrDefault("quotaUser")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "quotaUser", valid_589086
  var valid_589087 = query.getOrDefault("alt")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("json"))
  if valid_589087 != nil:
    section.add "alt", valid_589087
  var valid_589088 = query.getOrDefault("oauth_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "oauth_token", valid_589088
  var valid_589089 = query.getOrDefault("userIp")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "userIp", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("prettyPrint")
  valid_589091 = validateParameter(valid_589091, JBool, required = false,
                                 default = newJBool(true))
  if valid_589091 != nil:
    section.add "prettyPrint", valid_589091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589092: Call_AdsenseAccountsAdunitsGetAdCode_589079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_589092.validator(path, query, header, formData, body)
  let scheme = call_589092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589092.url(scheme.get, call_589092.host, call_589092.base,
                         call_589092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589092, url, valid)

proc call*(call_589093: Call_AdsenseAccountsAdunitsGetAdCode_589079;
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
  var path_589094 = newJObject()
  var query_589095 = newJObject()
  add(query_589095, "fields", newJString(fields))
  add(query_589095, "quotaUser", newJString(quotaUser))
  add(query_589095, "alt", newJString(alt))
  add(query_589095, "oauth_token", newJString(oauthToken))
  add(path_589094, "accountId", newJString(accountId))
  add(query_589095, "userIp", newJString(userIp))
  add(query_589095, "key", newJString(key))
  add(path_589094, "adClientId", newJString(adClientId))
  add(path_589094, "adUnitId", newJString(adUnitId))
  add(query_589095, "prettyPrint", newJBool(prettyPrint))
  result = call_589093.call(path_589094, query_589095, nil, nil, nil)

var adsenseAccountsAdunitsGetAdCode* = Call_AdsenseAccountsAdunitsGetAdCode_589079(
    name: "adsenseAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAccountsAdunitsGetAdCode_589080,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdunitsGetAdCode_589081,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsCustomchannelsList_589096 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsAdunitsCustomchannelsList_589098(protocol: Scheme;
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

proc validate_AdsenseAccountsAdunitsCustomchannelsList_589097(path: JsonNode;
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
  var valid_589099 = path.getOrDefault("accountId")
  valid_589099 = validateParameter(valid_589099, JString, required = true,
                                 default = nil)
  if valid_589099 != nil:
    section.add "accountId", valid_589099
  var valid_589100 = path.getOrDefault("adClientId")
  valid_589100 = validateParameter(valid_589100, JString, required = true,
                                 default = nil)
  if valid_589100 != nil:
    section.add "adClientId", valid_589100
  var valid_589101 = path.getOrDefault("adUnitId")
  valid_589101 = validateParameter(valid_589101, JString, required = true,
                                 default = nil)
  if valid_589101 != nil:
    section.add "adUnitId", valid_589101
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
  var valid_589102 = query.getOrDefault("fields")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "fields", valid_589102
  var valid_589103 = query.getOrDefault("pageToken")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "pageToken", valid_589103
  var valid_589104 = query.getOrDefault("quotaUser")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "quotaUser", valid_589104
  var valid_589105 = query.getOrDefault("alt")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("json"))
  if valid_589105 != nil:
    section.add "alt", valid_589105
  var valid_589106 = query.getOrDefault("oauth_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "oauth_token", valid_589106
  var valid_589107 = query.getOrDefault("userIp")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "userIp", valid_589107
  var valid_589108 = query.getOrDefault("maxResults")
  valid_589108 = validateParameter(valid_589108, JInt, required = false, default = nil)
  if valid_589108 != nil:
    section.add "maxResults", valid_589108
  var valid_589109 = query.getOrDefault("key")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "key", valid_589109
  var valid_589110 = query.getOrDefault("prettyPrint")
  valid_589110 = validateParameter(valid_589110, JBool, required = false,
                                 default = newJBool(true))
  if valid_589110 != nil:
    section.add "prettyPrint", valid_589110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589111: Call_AdsenseAccountsAdunitsCustomchannelsList_589096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_589111.validator(path, query, header, formData, body)
  let scheme = call_589111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589111.url(scheme.get, call_589111.host, call_589111.base,
                         call_589111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589111, url, valid)

proc call*(call_589112: Call_AdsenseAccountsAdunitsCustomchannelsList_589096;
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
  var path_589113 = newJObject()
  var query_589114 = newJObject()
  add(query_589114, "fields", newJString(fields))
  add(query_589114, "pageToken", newJString(pageToken))
  add(query_589114, "quotaUser", newJString(quotaUser))
  add(query_589114, "alt", newJString(alt))
  add(query_589114, "oauth_token", newJString(oauthToken))
  add(path_589113, "accountId", newJString(accountId))
  add(query_589114, "userIp", newJString(userIp))
  add(query_589114, "maxResults", newJInt(maxResults))
  add(query_589114, "key", newJString(key))
  add(path_589113, "adClientId", newJString(adClientId))
  add(path_589113, "adUnitId", newJString(adUnitId))
  add(query_589114, "prettyPrint", newJBool(prettyPrint))
  result = call_589112.call(path_589113, query_589114, nil, nil, nil)

var adsenseAccountsAdunitsCustomchannelsList* = Call_AdsenseAccountsAdunitsCustomchannelsList_589096(
    name: "adsenseAccountsAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAccountsAdunitsCustomchannelsList_589097,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdunitsCustomchannelsList_589098,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsList_589115 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsCustomchannelsList_589117(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsCustomchannelsList_589116(path: JsonNode;
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
  var valid_589118 = path.getOrDefault("accountId")
  valid_589118 = validateParameter(valid_589118, JString, required = true,
                                 default = nil)
  if valid_589118 != nil:
    section.add "accountId", valid_589118
  var valid_589119 = path.getOrDefault("adClientId")
  valid_589119 = validateParameter(valid_589119, JString, required = true,
                                 default = nil)
  if valid_589119 != nil:
    section.add "adClientId", valid_589119
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
  var valid_589120 = query.getOrDefault("fields")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "fields", valid_589120
  var valid_589121 = query.getOrDefault("pageToken")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "pageToken", valid_589121
  var valid_589122 = query.getOrDefault("quotaUser")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "quotaUser", valid_589122
  var valid_589123 = query.getOrDefault("alt")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = newJString("json"))
  if valid_589123 != nil:
    section.add "alt", valid_589123
  var valid_589124 = query.getOrDefault("oauth_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "oauth_token", valid_589124
  var valid_589125 = query.getOrDefault("userIp")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "userIp", valid_589125
  var valid_589126 = query.getOrDefault("maxResults")
  valid_589126 = validateParameter(valid_589126, JInt, required = false, default = nil)
  if valid_589126 != nil:
    section.add "maxResults", valid_589126
  var valid_589127 = query.getOrDefault("key")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "key", valid_589127
  var valid_589128 = query.getOrDefault("prettyPrint")
  valid_589128 = validateParameter(valid_589128, JBool, required = false,
                                 default = newJBool(true))
  if valid_589128 != nil:
    section.add "prettyPrint", valid_589128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589129: Call_AdsenseAccountsCustomchannelsList_589115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for the specified account.
  ## 
  let valid = call_589129.validator(path, query, header, formData, body)
  let scheme = call_589129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589129.url(scheme.get, call_589129.host, call_589129.base,
                         call_589129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589129, url, valid)

proc call*(call_589130: Call_AdsenseAccountsCustomchannelsList_589115;
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
  var path_589131 = newJObject()
  var query_589132 = newJObject()
  add(query_589132, "fields", newJString(fields))
  add(query_589132, "pageToken", newJString(pageToken))
  add(query_589132, "quotaUser", newJString(quotaUser))
  add(query_589132, "alt", newJString(alt))
  add(query_589132, "oauth_token", newJString(oauthToken))
  add(path_589131, "accountId", newJString(accountId))
  add(query_589132, "userIp", newJString(userIp))
  add(query_589132, "maxResults", newJInt(maxResults))
  add(query_589132, "key", newJString(key))
  add(path_589131, "adClientId", newJString(adClientId))
  add(query_589132, "prettyPrint", newJBool(prettyPrint))
  result = call_589130.call(path_589131, query_589132, nil, nil, nil)

var adsenseAccountsCustomchannelsList* = Call_AdsenseAccountsCustomchannelsList_589115(
    name: "adsenseAccountsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseAccountsCustomchannelsList_589116,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsList_589117,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsGet_589133 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsCustomchannelsGet_589135(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsCustomchannelsGet_589134(path: JsonNode;
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
  var valid_589136 = path.getOrDefault("accountId")
  valid_589136 = validateParameter(valid_589136, JString, required = true,
                                 default = nil)
  if valid_589136 != nil:
    section.add "accountId", valid_589136
  var valid_589137 = path.getOrDefault("customChannelId")
  valid_589137 = validateParameter(valid_589137, JString, required = true,
                                 default = nil)
  if valid_589137 != nil:
    section.add "customChannelId", valid_589137
  var valid_589138 = path.getOrDefault("adClientId")
  valid_589138 = validateParameter(valid_589138, JString, required = true,
                                 default = nil)
  if valid_589138 != nil:
    section.add "adClientId", valid_589138
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
  var valid_589139 = query.getOrDefault("fields")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "fields", valid_589139
  var valid_589140 = query.getOrDefault("quotaUser")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "quotaUser", valid_589140
  var valid_589141 = query.getOrDefault("alt")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = newJString("json"))
  if valid_589141 != nil:
    section.add "alt", valid_589141
  var valid_589142 = query.getOrDefault("oauth_token")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "oauth_token", valid_589142
  var valid_589143 = query.getOrDefault("userIp")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "userIp", valid_589143
  var valid_589144 = query.getOrDefault("key")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "key", valid_589144
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

proc call*(call_589146: Call_AdsenseAccountsCustomchannelsGet_589133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client for the specified account.
  ## 
  let valid = call_589146.validator(path, query, header, formData, body)
  let scheme = call_589146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589146.url(scheme.get, call_589146.host, call_589146.base,
                         call_589146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589146, url, valid)

proc call*(call_589147: Call_AdsenseAccountsCustomchannelsGet_589133;
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
  var path_589148 = newJObject()
  var query_589149 = newJObject()
  add(query_589149, "fields", newJString(fields))
  add(query_589149, "quotaUser", newJString(quotaUser))
  add(query_589149, "alt", newJString(alt))
  add(query_589149, "oauth_token", newJString(oauthToken))
  add(path_589148, "accountId", newJString(accountId))
  add(path_589148, "customChannelId", newJString(customChannelId))
  add(query_589149, "userIp", newJString(userIp))
  add(query_589149, "key", newJString(key))
  add(path_589148, "adClientId", newJString(adClientId))
  add(query_589149, "prettyPrint", newJBool(prettyPrint))
  result = call_589147.call(path_589148, query_589149, nil, nil, nil)

var adsenseAccountsCustomchannelsGet* = Call_AdsenseAccountsCustomchannelsGet_589133(
    name: "adsenseAccountsCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseAccountsCustomchannelsGet_589134,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsGet_589135,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsAdunitsList_589150 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsCustomchannelsAdunitsList_589152(protocol: Scheme;
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

proc validate_AdsenseAccountsCustomchannelsAdunitsList_589151(path: JsonNode;
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
  var valid_589153 = path.getOrDefault("accountId")
  valid_589153 = validateParameter(valid_589153, JString, required = true,
                                 default = nil)
  if valid_589153 != nil:
    section.add "accountId", valid_589153
  var valid_589154 = path.getOrDefault("customChannelId")
  valid_589154 = validateParameter(valid_589154, JString, required = true,
                                 default = nil)
  if valid_589154 != nil:
    section.add "customChannelId", valid_589154
  var valid_589155 = path.getOrDefault("adClientId")
  valid_589155 = validateParameter(valid_589155, JString, required = true,
                                 default = nil)
  if valid_589155 != nil:
    section.add "adClientId", valid_589155
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
  var valid_589156 = query.getOrDefault("fields")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "fields", valid_589156
  var valid_589157 = query.getOrDefault("pageToken")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "pageToken", valid_589157
  var valid_589158 = query.getOrDefault("quotaUser")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "quotaUser", valid_589158
  var valid_589159 = query.getOrDefault("alt")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("json"))
  if valid_589159 != nil:
    section.add "alt", valid_589159
  var valid_589160 = query.getOrDefault("includeInactive")
  valid_589160 = validateParameter(valid_589160, JBool, required = false, default = nil)
  if valid_589160 != nil:
    section.add "includeInactive", valid_589160
  var valid_589161 = query.getOrDefault("oauth_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "oauth_token", valid_589161
  var valid_589162 = query.getOrDefault("userIp")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "userIp", valid_589162
  var valid_589163 = query.getOrDefault("maxResults")
  valid_589163 = validateParameter(valid_589163, JInt, required = false, default = nil)
  if valid_589163 != nil:
    section.add "maxResults", valid_589163
  var valid_589164 = query.getOrDefault("key")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "key", valid_589164
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

proc call*(call_589166: Call_AdsenseAccountsCustomchannelsAdunitsList_589150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_589166.validator(path, query, header, formData, body)
  let scheme = call_589166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589166.url(scheme.get, call_589166.host, call_589166.base,
                         call_589166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589166, url, valid)

proc call*(call_589167: Call_AdsenseAccountsCustomchannelsAdunitsList_589150;
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
  var path_589168 = newJObject()
  var query_589169 = newJObject()
  add(query_589169, "fields", newJString(fields))
  add(query_589169, "pageToken", newJString(pageToken))
  add(query_589169, "quotaUser", newJString(quotaUser))
  add(query_589169, "alt", newJString(alt))
  add(query_589169, "includeInactive", newJBool(includeInactive))
  add(query_589169, "oauth_token", newJString(oauthToken))
  add(path_589168, "accountId", newJString(accountId))
  add(path_589168, "customChannelId", newJString(customChannelId))
  add(query_589169, "userIp", newJString(userIp))
  add(query_589169, "maxResults", newJInt(maxResults))
  add(query_589169, "key", newJString(key))
  add(path_589168, "adClientId", newJString(adClientId))
  add(query_589169, "prettyPrint", newJBool(prettyPrint))
  result = call_589167.call(path_589168, query_589169, nil, nil, nil)

var adsenseAccountsCustomchannelsAdunitsList* = Call_AdsenseAccountsCustomchannelsAdunitsList_589150(
    name: "adsenseAccountsCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseAccountsCustomchannelsAdunitsList_589151,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsAdunitsList_589152,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsUrlchannelsList_589170 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsUrlchannelsList_589172(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsUrlchannelsList_589171(path: JsonNode;
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
  var valid_589173 = path.getOrDefault("accountId")
  valid_589173 = validateParameter(valid_589173, JString, required = true,
                                 default = nil)
  if valid_589173 != nil:
    section.add "accountId", valid_589173
  var valid_589174 = path.getOrDefault("adClientId")
  valid_589174 = validateParameter(valid_589174, JString, required = true,
                                 default = nil)
  if valid_589174 != nil:
    section.add "adClientId", valid_589174
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
  var valid_589178 = query.getOrDefault("alt")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = newJString("json"))
  if valid_589178 != nil:
    section.add "alt", valid_589178
  var valid_589179 = query.getOrDefault("oauth_token")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "oauth_token", valid_589179
  var valid_589180 = query.getOrDefault("userIp")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "userIp", valid_589180
  var valid_589181 = query.getOrDefault("maxResults")
  valid_589181 = validateParameter(valid_589181, JInt, required = false, default = nil)
  if valid_589181 != nil:
    section.add "maxResults", valid_589181
  var valid_589182 = query.getOrDefault("key")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "key", valid_589182
  var valid_589183 = query.getOrDefault("prettyPrint")
  valid_589183 = validateParameter(valid_589183, JBool, required = false,
                                 default = newJBool(true))
  if valid_589183 != nil:
    section.add "prettyPrint", valid_589183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589184: Call_AdsenseAccountsUrlchannelsList_589170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for the specified account.
  ## 
  let valid = call_589184.validator(path, query, header, formData, body)
  let scheme = call_589184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589184.url(scheme.get, call_589184.host, call_589184.base,
                         call_589184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589184, url, valid)

proc call*(call_589185: Call_AdsenseAccountsUrlchannelsList_589170;
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
  var path_589186 = newJObject()
  var query_589187 = newJObject()
  add(query_589187, "fields", newJString(fields))
  add(query_589187, "pageToken", newJString(pageToken))
  add(query_589187, "quotaUser", newJString(quotaUser))
  add(query_589187, "alt", newJString(alt))
  add(query_589187, "oauth_token", newJString(oauthToken))
  add(path_589186, "accountId", newJString(accountId))
  add(query_589187, "userIp", newJString(userIp))
  add(query_589187, "maxResults", newJInt(maxResults))
  add(query_589187, "key", newJString(key))
  add(path_589186, "adClientId", newJString(adClientId))
  add(query_589187, "prettyPrint", newJBool(prettyPrint))
  result = call_589185.call(path_589186, query_589187, nil, nil, nil)

var adsenseAccountsUrlchannelsList* = Call_AdsenseAccountsUrlchannelsList_589170(
    name: "adsenseAccountsUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseAccountsUrlchannelsList_589171,
    base: "/adsense/v1.3", url: url_AdsenseAccountsUrlchannelsList_589172,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAlertsList_589188 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsAlertsList_589190(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAlertsList_589189(path: JsonNode; query: JsonNode;
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
  var valid_589191 = path.getOrDefault("accountId")
  valid_589191 = validateParameter(valid_589191, JString, required = true,
                                 default = nil)
  if valid_589191 != nil:
    section.add "accountId", valid_589191
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
  var valid_589192 = query.getOrDefault("locale")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "locale", valid_589192
  var valid_589193 = query.getOrDefault("fields")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "fields", valid_589193
  var valid_589194 = query.getOrDefault("quotaUser")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "quotaUser", valid_589194
  var valid_589195 = query.getOrDefault("alt")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = newJString("json"))
  if valid_589195 != nil:
    section.add "alt", valid_589195
  var valid_589196 = query.getOrDefault("oauth_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "oauth_token", valid_589196
  var valid_589197 = query.getOrDefault("userIp")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "userIp", valid_589197
  var valid_589198 = query.getOrDefault("key")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "key", valid_589198
  var valid_589199 = query.getOrDefault("prettyPrint")
  valid_589199 = validateParameter(valid_589199, JBool, required = false,
                                 default = newJBool(true))
  if valid_589199 != nil:
    section.add "prettyPrint", valid_589199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589200: Call_AdsenseAccountsAlertsList_589188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for the specified AdSense account.
  ## 
  let valid = call_589200.validator(path, query, header, formData, body)
  let scheme = call_589200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589200.url(scheme.get, call_589200.host, call_589200.base,
                         call_589200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589200, url, valid)

proc call*(call_589201: Call_AdsenseAccountsAlertsList_589188; accountId: string;
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
  var path_589202 = newJObject()
  var query_589203 = newJObject()
  add(query_589203, "locale", newJString(locale))
  add(query_589203, "fields", newJString(fields))
  add(query_589203, "quotaUser", newJString(quotaUser))
  add(query_589203, "alt", newJString(alt))
  add(query_589203, "oauth_token", newJString(oauthToken))
  add(path_589202, "accountId", newJString(accountId))
  add(query_589203, "userIp", newJString(userIp))
  add(query_589203, "key", newJString(key))
  add(query_589203, "prettyPrint", newJBool(prettyPrint))
  result = call_589201.call(path_589202, query_589203, nil, nil, nil)

var adsenseAccountsAlertsList* = Call_AdsenseAccountsAlertsList_589188(
    name: "adsenseAccountsAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts",
    validator: validate_AdsenseAccountsAlertsList_589189, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAlertsList_589190, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsGenerate_589204 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsReportsGenerate_589206(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsGenerate_589205(path: JsonNode;
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
  var valid_589207 = path.getOrDefault("accountId")
  valid_589207 = validateParameter(valid_589207, JString, required = true,
                                 default = nil)
  if valid_589207 != nil:
    section.add "accountId", valid_589207
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
  var valid_589208 = query.getOrDefault("useTimezoneReporting")
  valid_589208 = validateParameter(valid_589208, JBool, required = false, default = nil)
  if valid_589208 != nil:
    section.add "useTimezoneReporting", valid_589208
  var valid_589209 = query.getOrDefault("locale")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "locale", valid_589209
  var valid_589210 = query.getOrDefault("fields")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "fields", valid_589210
  var valid_589211 = query.getOrDefault("quotaUser")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "quotaUser", valid_589211
  var valid_589212 = query.getOrDefault("alt")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = newJString("json"))
  if valid_589212 != nil:
    section.add "alt", valid_589212
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_589213 = query.getOrDefault("endDate")
  valid_589213 = validateParameter(valid_589213, JString, required = true,
                                 default = nil)
  if valid_589213 != nil:
    section.add "endDate", valid_589213
  var valid_589214 = query.getOrDefault("currency")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "currency", valid_589214
  var valid_589215 = query.getOrDefault("startDate")
  valid_589215 = validateParameter(valid_589215, JString, required = true,
                                 default = nil)
  if valid_589215 != nil:
    section.add "startDate", valid_589215
  var valid_589216 = query.getOrDefault("sort")
  valid_589216 = validateParameter(valid_589216, JArray, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "sort", valid_589216
  var valid_589217 = query.getOrDefault("oauth_token")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "oauth_token", valid_589217
  var valid_589218 = query.getOrDefault("userIp")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "userIp", valid_589218
  var valid_589219 = query.getOrDefault("maxResults")
  valid_589219 = validateParameter(valid_589219, JInt, required = false, default = nil)
  if valid_589219 != nil:
    section.add "maxResults", valid_589219
  var valid_589220 = query.getOrDefault("key")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "key", valid_589220
  var valid_589221 = query.getOrDefault("metric")
  valid_589221 = validateParameter(valid_589221, JArray, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "metric", valid_589221
  var valid_589222 = query.getOrDefault("prettyPrint")
  valid_589222 = validateParameter(valid_589222, JBool, required = false,
                                 default = newJBool(true))
  if valid_589222 != nil:
    section.add "prettyPrint", valid_589222
  var valid_589223 = query.getOrDefault("dimension")
  valid_589223 = validateParameter(valid_589223, JArray, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "dimension", valid_589223
  var valid_589224 = query.getOrDefault("filter")
  valid_589224 = validateParameter(valid_589224, JArray, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "filter", valid_589224
  var valid_589225 = query.getOrDefault("startIndex")
  valid_589225 = validateParameter(valid_589225, JInt, required = false, default = nil)
  if valid_589225 != nil:
    section.add "startIndex", valid_589225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589226: Call_AdsenseAccountsReportsGenerate_589204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_589226.validator(path, query, header, formData, body)
  let scheme = call_589226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589226.url(scheme.get, call_589226.host, call_589226.base,
                         call_589226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589226, url, valid)

proc call*(call_589227: Call_AdsenseAccountsReportsGenerate_589204;
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
  var path_589228 = newJObject()
  var query_589229 = newJObject()
  add(query_589229, "useTimezoneReporting", newJBool(useTimezoneReporting))
  add(query_589229, "locale", newJString(locale))
  add(query_589229, "fields", newJString(fields))
  add(query_589229, "quotaUser", newJString(quotaUser))
  add(query_589229, "alt", newJString(alt))
  add(query_589229, "endDate", newJString(endDate))
  add(query_589229, "currency", newJString(currency))
  add(query_589229, "startDate", newJString(startDate))
  if sort != nil:
    query_589229.add "sort", sort
  add(query_589229, "oauth_token", newJString(oauthToken))
  add(path_589228, "accountId", newJString(accountId))
  add(query_589229, "userIp", newJString(userIp))
  add(query_589229, "maxResults", newJInt(maxResults))
  add(query_589229, "key", newJString(key))
  if metric != nil:
    query_589229.add "metric", metric
  add(query_589229, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_589229.add "dimension", dimension
  if filter != nil:
    query_589229.add "filter", filter
  add(query_589229, "startIndex", newJInt(startIndex))
  result = call_589227.call(path_589228, query_589229, nil, nil, nil)

var adsenseAccountsReportsGenerate* = Call_AdsenseAccountsReportsGenerate_589204(
    name: "adsenseAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsenseAccountsReportsGenerate_589205,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsGenerate_589206,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedList_589230 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsReportsSavedList_589232(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsSavedList_589231(path: JsonNode;
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
  var valid_589233 = path.getOrDefault("accountId")
  valid_589233 = validateParameter(valid_589233, JString, required = true,
                                 default = nil)
  if valid_589233 != nil:
    section.add "accountId", valid_589233
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
  var valid_589234 = query.getOrDefault("fields")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "fields", valid_589234
  var valid_589235 = query.getOrDefault("pageToken")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "pageToken", valid_589235
  var valid_589236 = query.getOrDefault("quotaUser")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "quotaUser", valid_589236
  var valid_589237 = query.getOrDefault("alt")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = newJString("json"))
  if valid_589237 != nil:
    section.add "alt", valid_589237
  var valid_589238 = query.getOrDefault("oauth_token")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "oauth_token", valid_589238
  var valid_589239 = query.getOrDefault("userIp")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "userIp", valid_589239
  var valid_589240 = query.getOrDefault("maxResults")
  valid_589240 = validateParameter(valid_589240, JInt, required = false, default = nil)
  if valid_589240 != nil:
    section.add "maxResults", valid_589240
  var valid_589241 = query.getOrDefault("key")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "key", valid_589241
  var valid_589242 = query.getOrDefault("prettyPrint")
  valid_589242 = validateParameter(valid_589242, JBool, required = false,
                                 default = newJBool(true))
  if valid_589242 != nil:
    section.add "prettyPrint", valid_589242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589243: Call_AdsenseAccountsReportsSavedList_589230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in the specified AdSense account.
  ## 
  let valid = call_589243.validator(path, query, header, formData, body)
  let scheme = call_589243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589243.url(scheme.get, call_589243.host, call_589243.base,
                         call_589243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589243, url, valid)

proc call*(call_589244: Call_AdsenseAccountsReportsSavedList_589230;
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
  var path_589245 = newJObject()
  var query_589246 = newJObject()
  add(query_589246, "fields", newJString(fields))
  add(query_589246, "pageToken", newJString(pageToken))
  add(query_589246, "quotaUser", newJString(quotaUser))
  add(query_589246, "alt", newJString(alt))
  add(query_589246, "oauth_token", newJString(oauthToken))
  add(path_589245, "accountId", newJString(accountId))
  add(query_589246, "userIp", newJString(userIp))
  add(query_589246, "maxResults", newJInt(maxResults))
  add(query_589246, "key", newJString(key))
  add(query_589246, "prettyPrint", newJBool(prettyPrint))
  result = call_589244.call(path_589245, query_589246, nil, nil, nil)

var adsenseAccountsReportsSavedList* = Call_AdsenseAccountsReportsSavedList_589230(
    name: "adsenseAccountsReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports/saved",
    validator: validate_AdsenseAccountsReportsSavedList_589231,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsSavedList_589232,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedGenerate_589247 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsReportsSavedGenerate_589249(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsSavedGenerate_589248(path: JsonNode;
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
  var valid_589250 = path.getOrDefault("accountId")
  valid_589250 = validateParameter(valid_589250, JString, required = true,
                                 default = nil)
  if valid_589250 != nil:
    section.add "accountId", valid_589250
  var valid_589251 = path.getOrDefault("savedReportId")
  valid_589251 = validateParameter(valid_589251, JString, required = true,
                                 default = nil)
  if valid_589251 != nil:
    section.add "savedReportId", valid_589251
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
  var valid_589252 = query.getOrDefault("locale")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "locale", valid_589252
  var valid_589253 = query.getOrDefault("fields")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "fields", valid_589253
  var valid_589254 = query.getOrDefault("quotaUser")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "quotaUser", valid_589254
  var valid_589255 = query.getOrDefault("alt")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = newJString("json"))
  if valid_589255 != nil:
    section.add "alt", valid_589255
  var valid_589256 = query.getOrDefault("oauth_token")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "oauth_token", valid_589256
  var valid_589257 = query.getOrDefault("userIp")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "userIp", valid_589257
  var valid_589258 = query.getOrDefault("maxResults")
  valid_589258 = validateParameter(valid_589258, JInt, required = false, default = nil)
  if valid_589258 != nil:
    section.add "maxResults", valid_589258
  var valid_589259 = query.getOrDefault("key")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "key", valid_589259
  var valid_589260 = query.getOrDefault("prettyPrint")
  valid_589260 = validateParameter(valid_589260, JBool, required = false,
                                 default = newJBool(true))
  if valid_589260 != nil:
    section.add "prettyPrint", valid_589260
  var valid_589261 = query.getOrDefault("startIndex")
  valid_589261 = validateParameter(valid_589261, JInt, required = false, default = nil)
  if valid_589261 != nil:
    section.add "startIndex", valid_589261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589262: Call_AdsenseAccountsReportsSavedGenerate_589247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_589262.validator(path, query, header, formData, body)
  let scheme = call_589262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589262.url(scheme.get, call_589262.host, call_589262.base,
                         call_589262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589262, url, valid)

proc call*(call_589263: Call_AdsenseAccountsReportsSavedGenerate_589247;
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
  var path_589264 = newJObject()
  var query_589265 = newJObject()
  add(query_589265, "locale", newJString(locale))
  add(query_589265, "fields", newJString(fields))
  add(query_589265, "quotaUser", newJString(quotaUser))
  add(query_589265, "alt", newJString(alt))
  add(query_589265, "oauth_token", newJString(oauthToken))
  add(path_589264, "accountId", newJString(accountId))
  add(query_589265, "userIp", newJString(userIp))
  add(path_589264, "savedReportId", newJString(savedReportId))
  add(query_589265, "maxResults", newJInt(maxResults))
  add(query_589265, "key", newJString(key))
  add(query_589265, "prettyPrint", newJBool(prettyPrint))
  add(query_589265, "startIndex", newJInt(startIndex))
  result = call_589263.call(path_589264, query_589265, nil, nil, nil)

var adsenseAccountsReportsSavedGenerate* = Call_AdsenseAccountsReportsSavedGenerate_589247(
    name: "adsenseAccountsReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/reports/{savedReportId}",
    validator: validate_AdsenseAccountsReportsSavedGenerate_589248,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsSavedGenerate_589249,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesList_589266 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsSavedadstylesList_589268(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsSavedadstylesList_589267(path: JsonNode;
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
  var valid_589269 = path.getOrDefault("accountId")
  valid_589269 = validateParameter(valid_589269, JString, required = true,
                                 default = nil)
  if valid_589269 != nil:
    section.add "accountId", valid_589269
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
  var valid_589270 = query.getOrDefault("fields")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "fields", valid_589270
  var valid_589271 = query.getOrDefault("pageToken")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "pageToken", valid_589271
  var valid_589272 = query.getOrDefault("quotaUser")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "quotaUser", valid_589272
  var valid_589273 = query.getOrDefault("alt")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = newJString("json"))
  if valid_589273 != nil:
    section.add "alt", valid_589273
  var valid_589274 = query.getOrDefault("oauth_token")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "oauth_token", valid_589274
  var valid_589275 = query.getOrDefault("userIp")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "userIp", valid_589275
  var valid_589276 = query.getOrDefault("maxResults")
  valid_589276 = validateParameter(valid_589276, JInt, required = false, default = nil)
  if valid_589276 != nil:
    section.add "maxResults", valid_589276
  var valid_589277 = query.getOrDefault("key")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "key", valid_589277
  var valid_589278 = query.getOrDefault("prettyPrint")
  valid_589278 = validateParameter(valid_589278, JBool, required = false,
                                 default = newJBool(true))
  if valid_589278 != nil:
    section.add "prettyPrint", valid_589278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589279: Call_AdsenseAccountsSavedadstylesList_589266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved ad styles in the specified account.
  ## 
  let valid = call_589279.validator(path, query, header, formData, body)
  let scheme = call_589279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589279.url(scheme.get, call_589279.host, call_589279.base,
                         call_589279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589279, url, valid)

proc call*(call_589280: Call_AdsenseAccountsSavedadstylesList_589266;
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
  var path_589281 = newJObject()
  var query_589282 = newJObject()
  add(query_589282, "fields", newJString(fields))
  add(query_589282, "pageToken", newJString(pageToken))
  add(query_589282, "quotaUser", newJString(quotaUser))
  add(query_589282, "alt", newJString(alt))
  add(query_589282, "oauth_token", newJString(oauthToken))
  add(path_589281, "accountId", newJString(accountId))
  add(query_589282, "userIp", newJString(userIp))
  add(query_589282, "maxResults", newJInt(maxResults))
  add(query_589282, "key", newJString(key))
  add(query_589282, "prettyPrint", newJBool(prettyPrint))
  result = call_589280.call(path_589281, query_589282, nil, nil, nil)

var adsenseAccountsSavedadstylesList* = Call_AdsenseAccountsSavedadstylesList_589266(
    name: "adsenseAccountsSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/savedadstyles",
    validator: validate_AdsenseAccountsSavedadstylesList_589267,
    base: "/adsense/v1.3", url: url_AdsenseAccountsSavedadstylesList_589268,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesGet_589283 = ref object of OpenApiRestCall_588457
proc url_AdsenseAccountsSavedadstylesGet_589285(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsSavedadstylesGet_589284(path: JsonNode;
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
  var valid_589286 = path.getOrDefault("accountId")
  valid_589286 = validateParameter(valid_589286, JString, required = true,
                                 default = nil)
  if valid_589286 != nil:
    section.add "accountId", valid_589286
  var valid_589287 = path.getOrDefault("savedAdStyleId")
  valid_589287 = validateParameter(valid_589287, JString, required = true,
                                 default = nil)
  if valid_589287 != nil:
    section.add "savedAdStyleId", valid_589287
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
  var valid_589288 = query.getOrDefault("fields")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "fields", valid_589288
  var valid_589289 = query.getOrDefault("quotaUser")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "quotaUser", valid_589289
  var valid_589290 = query.getOrDefault("alt")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = newJString("json"))
  if valid_589290 != nil:
    section.add "alt", valid_589290
  var valid_589291 = query.getOrDefault("oauth_token")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "oauth_token", valid_589291
  var valid_589292 = query.getOrDefault("userIp")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "userIp", valid_589292
  var valid_589293 = query.getOrDefault("key")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "key", valid_589293
  var valid_589294 = query.getOrDefault("prettyPrint")
  valid_589294 = validateParameter(valid_589294, JBool, required = false,
                                 default = newJBool(true))
  if valid_589294 != nil:
    section.add "prettyPrint", valid_589294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589295: Call_AdsenseAccountsSavedadstylesGet_589283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a specific saved ad style for the specified account.
  ## 
  let valid = call_589295.validator(path, query, header, formData, body)
  let scheme = call_589295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589295.url(scheme.get, call_589295.host, call_589295.base,
                         call_589295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589295, url, valid)

proc call*(call_589296: Call_AdsenseAccountsSavedadstylesGet_589283;
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
  var path_589297 = newJObject()
  var query_589298 = newJObject()
  add(query_589298, "fields", newJString(fields))
  add(query_589298, "quotaUser", newJString(quotaUser))
  add(query_589298, "alt", newJString(alt))
  add(query_589298, "oauth_token", newJString(oauthToken))
  add(path_589297, "accountId", newJString(accountId))
  add(path_589297, "savedAdStyleId", newJString(savedAdStyleId))
  add(query_589298, "userIp", newJString(userIp))
  add(query_589298, "key", newJString(key))
  add(query_589298, "prettyPrint", newJBool(prettyPrint))
  result = call_589296.call(path_589297, query_589298, nil, nil, nil)

var adsenseAccountsSavedadstylesGet* = Call_AdsenseAccountsSavedadstylesGet_589283(
    name: "adsenseAccountsSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseAccountsSavedadstylesGet_589284,
    base: "/adsense/v1.3", url: url_AdsenseAccountsSavedadstylesGet_589285,
    schemes: {Scheme.Https})
type
  Call_AdsenseAdclientsList_589299 = ref object of OpenApiRestCall_588457
proc url_AdsenseAdclientsList_589301(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAdclientsList_589300(path: JsonNode; query: JsonNode;
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
  var valid_589302 = query.getOrDefault("fields")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "fields", valid_589302
  var valid_589303 = query.getOrDefault("pageToken")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "pageToken", valid_589303
  var valid_589304 = query.getOrDefault("quotaUser")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "quotaUser", valid_589304
  var valid_589305 = query.getOrDefault("alt")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = newJString("json"))
  if valid_589305 != nil:
    section.add "alt", valid_589305
  var valid_589306 = query.getOrDefault("oauth_token")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "oauth_token", valid_589306
  var valid_589307 = query.getOrDefault("userIp")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "userIp", valid_589307
  var valid_589308 = query.getOrDefault("maxResults")
  valid_589308 = validateParameter(valid_589308, JInt, required = false, default = nil)
  if valid_589308 != nil:
    section.add "maxResults", valid_589308
  var valid_589309 = query.getOrDefault("key")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "key", valid_589309
  var valid_589310 = query.getOrDefault("prettyPrint")
  valid_589310 = validateParameter(valid_589310, JBool, required = false,
                                 default = newJBool(true))
  if valid_589310 != nil:
    section.add "prettyPrint", valid_589310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589311: Call_AdsenseAdclientsList_589299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this AdSense account.
  ## 
  let valid = call_589311.validator(path, query, header, formData, body)
  let scheme = call_589311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589311.url(scheme.get, call_589311.host, call_589311.base,
                         call_589311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589311, url, valid)

proc call*(call_589312: Call_AdsenseAdclientsList_589299; fields: string = "";
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
  var query_589313 = newJObject()
  add(query_589313, "fields", newJString(fields))
  add(query_589313, "pageToken", newJString(pageToken))
  add(query_589313, "quotaUser", newJString(quotaUser))
  add(query_589313, "alt", newJString(alt))
  add(query_589313, "oauth_token", newJString(oauthToken))
  add(query_589313, "userIp", newJString(userIp))
  add(query_589313, "maxResults", newJInt(maxResults))
  add(query_589313, "key", newJString(key))
  add(query_589313, "prettyPrint", newJBool(prettyPrint))
  result = call_589312.call(nil, query_589313, nil, nil, nil)

var adsenseAdclientsList* = Call_AdsenseAdclientsList_589299(
    name: "adsenseAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsenseAdclientsList_589300, base: "/adsense/v1.3",
    url: url_AdsenseAdclientsList_589301, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsList_589314 = ref object of OpenApiRestCall_588457
proc url_AdsenseAdunitsList_589316(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsList_589315(path: JsonNode; query: JsonNode;
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
  var valid_589317 = path.getOrDefault("adClientId")
  valid_589317 = validateParameter(valid_589317, JString, required = true,
                                 default = nil)
  if valid_589317 != nil:
    section.add "adClientId", valid_589317
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
  var valid_589318 = query.getOrDefault("fields")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "fields", valid_589318
  var valid_589319 = query.getOrDefault("pageToken")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "pageToken", valid_589319
  var valid_589320 = query.getOrDefault("quotaUser")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "quotaUser", valid_589320
  var valid_589321 = query.getOrDefault("alt")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("json"))
  if valid_589321 != nil:
    section.add "alt", valid_589321
  var valid_589322 = query.getOrDefault("includeInactive")
  valid_589322 = validateParameter(valid_589322, JBool, required = false, default = nil)
  if valid_589322 != nil:
    section.add "includeInactive", valid_589322
  var valid_589323 = query.getOrDefault("oauth_token")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "oauth_token", valid_589323
  var valid_589324 = query.getOrDefault("userIp")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "userIp", valid_589324
  var valid_589325 = query.getOrDefault("maxResults")
  valid_589325 = validateParameter(valid_589325, JInt, required = false, default = nil)
  if valid_589325 != nil:
    section.add "maxResults", valid_589325
  var valid_589326 = query.getOrDefault("key")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "key", valid_589326
  var valid_589327 = query.getOrDefault("prettyPrint")
  valid_589327 = validateParameter(valid_589327, JBool, required = false,
                                 default = newJBool(true))
  if valid_589327 != nil:
    section.add "prettyPrint", valid_589327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589328: Call_AdsenseAdunitsList_589314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this AdSense account.
  ## 
  let valid = call_589328.validator(path, query, header, formData, body)
  let scheme = call_589328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589328.url(scheme.get, call_589328.host, call_589328.base,
                         call_589328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589328, url, valid)

proc call*(call_589329: Call_AdsenseAdunitsList_589314; adClientId: string;
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
  var path_589330 = newJObject()
  var query_589331 = newJObject()
  add(query_589331, "fields", newJString(fields))
  add(query_589331, "pageToken", newJString(pageToken))
  add(query_589331, "quotaUser", newJString(quotaUser))
  add(query_589331, "alt", newJString(alt))
  add(query_589331, "includeInactive", newJBool(includeInactive))
  add(query_589331, "oauth_token", newJString(oauthToken))
  add(query_589331, "userIp", newJString(userIp))
  add(query_589331, "maxResults", newJInt(maxResults))
  add(query_589331, "key", newJString(key))
  add(path_589330, "adClientId", newJString(adClientId))
  add(query_589331, "prettyPrint", newJBool(prettyPrint))
  result = call_589329.call(path_589330, query_589331, nil, nil, nil)

var adsenseAdunitsList* = Call_AdsenseAdunitsList_589314(
    name: "adsenseAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAdunitsList_589315, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsList_589316, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGet_589332 = ref object of OpenApiRestCall_588457
proc url_AdsenseAdunitsGet_589334(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsGet_589333(path: JsonNode; query: JsonNode;
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
  var valid_589335 = path.getOrDefault("adClientId")
  valid_589335 = validateParameter(valid_589335, JString, required = true,
                                 default = nil)
  if valid_589335 != nil:
    section.add "adClientId", valid_589335
  var valid_589336 = path.getOrDefault("adUnitId")
  valid_589336 = validateParameter(valid_589336, JString, required = true,
                                 default = nil)
  if valid_589336 != nil:
    section.add "adUnitId", valid_589336
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
  var valid_589337 = query.getOrDefault("fields")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "fields", valid_589337
  var valid_589338 = query.getOrDefault("quotaUser")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "quotaUser", valid_589338
  var valid_589339 = query.getOrDefault("alt")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = newJString("json"))
  if valid_589339 != nil:
    section.add "alt", valid_589339
  var valid_589340 = query.getOrDefault("oauth_token")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "oauth_token", valid_589340
  var valid_589341 = query.getOrDefault("userIp")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "userIp", valid_589341
  var valid_589342 = query.getOrDefault("key")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "key", valid_589342
  var valid_589343 = query.getOrDefault("prettyPrint")
  valid_589343 = validateParameter(valid_589343, JBool, required = false,
                                 default = newJBool(true))
  if valid_589343 != nil:
    section.add "prettyPrint", valid_589343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589344: Call_AdsenseAdunitsGet_589332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_589344.validator(path, query, header, formData, body)
  let scheme = call_589344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589344.url(scheme.get, call_589344.host, call_589344.base,
                         call_589344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589344, url, valid)

proc call*(call_589345: Call_AdsenseAdunitsGet_589332; adClientId: string;
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
  var path_589346 = newJObject()
  var query_589347 = newJObject()
  add(query_589347, "fields", newJString(fields))
  add(query_589347, "quotaUser", newJString(quotaUser))
  add(query_589347, "alt", newJString(alt))
  add(query_589347, "oauth_token", newJString(oauthToken))
  add(query_589347, "userIp", newJString(userIp))
  add(query_589347, "key", newJString(key))
  add(path_589346, "adClientId", newJString(adClientId))
  add(path_589346, "adUnitId", newJString(adUnitId))
  add(query_589347, "prettyPrint", newJBool(prettyPrint))
  result = call_589345.call(path_589346, query_589347, nil, nil, nil)

var adsenseAdunitsGet* = Call_AdsenseAdunitsGet_589332(name: "adsenseAdunitsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAdunitsGet_589333, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsGet_589334, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGetAdCode_589348 = ref object of OpenApiRestCall_588457
proc url_AdsenseAdunitsGetAdCode_589350(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsGetAdCode_589349(path: JsonNode; query: JsonNode;
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
  var valid_589351 = path.getOrDefault("adClientId")
  valid_589351 = validateParameter(valid_589351, JString, required = true,
                                 default = nil)
  if valid_589351 != nil:
    section.add "adClientId", valid_589351
  var valid_589352 = path.getOrDefault("adUnitId")
  valid_589352 = validateParameter(valid_589352, JString, required = true,
                                 default = nil)
  if valid_589352 != nil:
    section.add "adUnitId", valid_589352
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
  var valid_589353 = query.getOrDefault("fields")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "fields", valid_589353
  var valid_589354 = query.getOrDefault("quotaUser")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "quotaUser", valid_589354
  var valid_589355 = query.getOrDefault("alt")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = newJString("json"))
  if valid_589355 != nil:
    section.add "alt", valid_589355
  var valid_589356 = query.getOrDefault("oauth_token")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "oauth_token", valid_589356
  var valid_589357 = query.getOrDefault("userIp")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "userIp", valid_589357
  var valid_589358 = query.getOrDefault("key")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "key", valid_589358
  var valid_589359 = query.getOrDefault("prettyPrint")
  valid_589359 = validateParameter(valid_589359, JBool, required = false,
                                 default = newJBool(true))
  if valid_589359 != nil:
    section.add "prettyPrint", valid_589359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589360: Call_AdsenseAdunitsGetAdCode_589348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_589360.validator(path, query, header, formData, body)
  let scheme = call_589360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589360.url(scheme.get, call_589360.host, call_589360.base,
                         call_589360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589360, url, valid)

proc call*(call_589361: Call_AdsenseAdunitsGetAdCode_589348; adClientId: string;
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
  var path_589362 = newJObject()
  var query_589363 = newJObject()
  add(query_589363, "fields", newJString(fields))
  add(query_589363, "quotaUser", newJString(quotaUser))
  add(query_589363, "alt", newJString(alt))
  add(query_589363, "oauth_token", newJString(oauthToken))
  add(query_589363, "userIp", newJString(userIp))
  add(query_589363, "key", newJString(key))
  add(path_589362, "adClientId", newJString(adClientId))
  add(path_589362, "adUnitId", newJString(adUnitId))
  add(query_589363, "prettyPrint", newJBool(prettyPrint))
  result = call_589361.call(path_589362, query_589363, nil, nil, nil)

var adsenseAdunitsGetAdCode* = Call_AdsenseAdunitsGetAdCode_589348(
    name: "adsenseAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAdunitsGetAdCode_589349, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsGetAdCode_589350, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsCustomchannelsList_589364 = ref object of OpenApiRestCall_588457
proc url_AdsenseAdunitsCustomchannelsList_589366(protocol: Scheme; host: string;
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

proc validate_AdsenseAdunitsCustomchannelsList_589365(path: JsonNode;
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
  var valid_589367 = path.getOrDefault("adClientId")
  valid_589367 = validateParameter(valid_589367, JString, required = true,
                                 default = nil)
  if valid_589367 != nil:
    section.add "adClientId", valid_589367
  var valid_589368 = path.getOrDefault("adUnitId")
  valid_589368 = validateParameter(valid_589368, JString, required = true,
                                 default = nil)
  if valid_589368 != nil:
    section.add "adUnitId", valid_589368
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
  var valid_589369 = query.getOrDefault("fields")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "fields", valid_589369
  var valid_589370 = query.getOrDefault("pageToken")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "pageToken", valid_589370
  var valid_589371 = query.getOrDefault("quotaUser")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "quotaUser", valid_589371
  var valid_589372 = query.getOrDefault("alt")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = newJString("json"))
  if valid_589372 != nil:
    section.add "alt", valid_589372
  var valid_589373 = query.getOrDefault("oauth_token")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "oauth_token", valid_589373
  var valid_589374 = query.getOrDefault("userIp")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "userIp", valid_589374
  var valid_589375 = query.getOrDefault("maxResults")
  valid_589375 = validateParameter(valid_589375, JInt, required = false, default = nil)
  if valid_589375 != nil:
    section.add "maxResults", valid_589375
  var valid_589376 = query.getOrDefault("key")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "key", valid_589376
  var valid_589377 = query.getOrDefault("prettyPrint")
  valid_589377 = validateParameter(valid_589377, JBool, required = false,
                                 default = newJBool(true))
  if valid_589377 != nil:
    section.add "prettyPrint", valid_589377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589378: Call_AdsenseAdunitsCustomchannelsList_589364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_589378.validator(path, query, header, formData, body)
  let scheme = call_589378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589378.url(scheme.get, call_589378.host, call_589378.base,
                         call_589378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589378, url, valid)

proc call*(call_589379: Call_AdsenseAdunitsCustomchannelsList_589364;
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
  var path_589380 = newJObject()
  var query_589381 = newJObject()
  add(query_589381, "fields", newJString(fields))
  add(query_589381, "pageToken", newJString(pageToken))
  add(query_589381, "quotaUser", newJString(quotaUser))
  add(query_589381, "alt", newJString(alt))
  add(query_589381, "oauth_token", newJString(oauthToken))
  add(query_589381, "userIp", newJString(userIp))
  add(query_589381, "maxResults", newJInt(maxResults))
  add(query_589381, "key", newJString(key))
  add(path_589380, "adClientId", newJString(adClientId))
  add(path_589380, "adUnitId", newJString(adUnitId))
  add(query_589381, "prettyPrint", newJBool(prettyPrint))
  result = call_589379.call(path_589380, query_589381, nil, nil, nil)

var adsenseAdunitsCustomchannelsList* = Call_AdsenseAdunitsCustomchannelsList_589364(
    name: "adsenseAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAdunitsCustomchannelsList_589365,
    base: "/adsense/v1.3", url: url_AdsenseAdunitsCustomchannelsList_589366,
    schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsList_589382 = ref object of OpenApiRestCall_588457
proc url_AdsenseCustomchannelsList_589384(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsList_589383(path: JsonNode; query: JsonNode;
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
  var valid_589385 = path.getOrDefault("adClientId")
  valid_589385 = validateParameter(valid_589385, JString, required = true,
                                 default = nil)
  if valid_589385 != nil:
    section.add "adClientId", valid_589385
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
  var valid_589386 = query.getOrDefault("fields")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "fields", valid_589386
  var valid_589387 = query.getOrDefault("pageToken")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "pageToken", valid_589387
  var valid_589388 = query.getOrDefault("quotaUser")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "quotaUser", valid_589388
  var valid_589389 = query.getOrDefault("alt")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = newJString("json"))
  if valid_589389 != nil:
    section.add "alt", valid_589389
  var valid_589390 = query.getOrDefault("oauth_token")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "oauth_token", valid_589390
  var valid_589391 = query.getOrDefault("userIp")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "userIp", valid_589391
  var valid_589392 = query.getOrDefault("maxResults")
  valid_589392 = validateParameter(valid_589392, JInt, required = false, default = nil)
  if valid_589392 != nil:
    section.add "maxResults", valid_589392
  var valid_589393 = query.getOrDefault("key")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "key", valid_589393
  var valid_589394 = query.getOrDefault("prettyPrint")
  valid_589394 = validateParameter(valid_589394, JBool, required = false,
                                 default = newJBool(true))
  if valid_589394 != nil:
    section.add "prettyPrint", valid_589394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589395: Call_AdsenseCustomchannelsList_589382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_589395.validator(path, query, header, formData, body)
  let scheme = call_589395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589395.url(scheme.get, call_589395.host, call_589395.base,
                         call_589395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589395, url, valid)

proc call*(call_589396: Call_AdsenseCustomchannelsList_589382; adClientId: string;
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
  var path_589397 = newJObject()
  var query_589398 = newJObject()
  add(query_589398, "fields", newJString(fields))
  add(query_589398, "pageToken", newJString(pageToken))
  add(query_589398, "quotaUser", newJString(quotaUser))
  add(query_589398, "alt", newJString(alt))
  add(query_589398, "oauth_token", newJString(oauthToken))
  add(query_589398, "userIp", newJString(userIp))
  add(query_589398, "maxResults", newJInt(maxResults))
  add(query_589398, "key", newJString(key))
  add(path_589397, "adClientId", newJString(adClientId))
  add(query_589398, "prettyPrint", newJBool(prettyPrint))
  result = call_589396.call(path_589397, query_589398, nil, nil, nil)

var adsenseCustomchannelsList* = Call_AdsenseCustomchannelsList_589382(
    name: "adsenseCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseCustomchannelsList_589383, base: "/adsense/v1.3",
    url: url_AdsenseCustomchannelsList_589384, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsGet_589399 = ref object of OpenApiRestCall_588457
proc url_AdsenseCustomchannelsGet_589401(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsGet_589400(path: JsonNode; query: JsonNode;
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
  var valid_589402 = path.getOrDefault("customChannelId")
  valid_589402 = validateParameter(valid_589402, JString, required = true,
                                 default = nil)
  if valid_589402 != nil:
    section.add "customChannelId", valid_589402
  var valid_589403 = path.getOrDefault("adClientId")
  valid_589403 = validateParameter(valid_589403, JString, required = true,
                                 default = nil)
  if valid_589403 != nil:
    section.add "adClientId", valid_589403
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
  var valid_589404 = query.getOrDefault("fields")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "fields", valid_589404
  var valid_589405 = query.getOrDefault("quotaUser")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "quotaUser", valid_589405
  var valid_589406 = query.getOrDefault("alt")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = newJString("json"))
  if valid_589406 != nil:
    section.add "alt", valid_589406
  var valid_589407 = query.getOrDefault("oauth_token")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "oauth_token", valid_589407
  var valid_589408 = query.getOrDefault("userIp")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "userIp", valid_589408
  var valid_589409 = query.getOrDefault("key")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "key", valid_589409
  var valid_589410 = query.getOrDefault("prettyPrint")
  valid_589410 = validateParameter(valid_589410, JBool, required = false,
                                 default = newJBool(true))
  if valid_589410 != nil:
    section.add "prettyPrint", valid_589410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589411: Call_AdsenseCustomchannelsGet_589399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_589411.validator(path, query, header, formData, body)
  let scheme = call_589411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589411.url(scheme.get, call_589411.host, call_589411.base,
                         call_589411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589411, url, valid)

proc call*(call_589412: Call_AdsenseCustomchannelsGet_589399;
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
  var path_589413 = newJObject()
  var query_589414 = newJObject()
  add(query_589414, "fields", newJString(fields))
  add(query_589414, "quotaUser", newJString(quotaUser))
  add(query_589414, "alt", newJString(alt))
  add(query_589414, "oauth_token", newJString(oauthToken))
  add(path_589413, "customChannelId", newJString(customChannelId))
  add(query_589414, "userIp", newJString(userIp))
  add(query_589414, "key", newJString(key))
  add(path_589413, "adClientId", newJString(adClientId))
  add(query_589414, "prettyPrint", newJBool(prettyPrint))
  result = call_589412.call(path_589413, query_589414, nil, nil, nil)

var adsenseCustomchannelsGet* = Call_AdsenseCustomchannelsGet_589399(
    name: "adsenseCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseCustomchannelsGet_589400, base: "/adsense/v1.3",
    url: url_AdsenseCustomchannelsGet_589401, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsAdunitsList_589415 = ref object of OpenApiRestCall_588457
proc url_AdsenseCustomchannelsAdunitsList_589417(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsAdunitsList_589416(path: JsonNode;
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
  var valid_589418 = path.getOrDefault("customChannelId")
  valid_589418 = validateParameter(valid_589418, JString, required = true,
                                 default = nil)
  if valid_589418 != nil:
    section.add "customChannelId", valid_589418
  var valid_589419 = path.getOrDefault("adClientId")
  valid_589419 = validateParameter(valid_589419, JString, required = true,
                                 default = nil)
  if valid_589419 != nil:
    section.add "adClientId", valid_589419
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
  var valid_589420 = query.getOrDefault("fields")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "fields", valid_589420
  var valid_589421 = query.getOrDefault("pageToken")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "pageToken", valid_589421
  var valid_589422 = query.getOrDefault("quotaUser")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "quotaUser", valid_589422
  var valid_589423 = query.getOrDefault("alt")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = newJString("json"))
  if valid_589423 != nil:
    section.add "alt", valid_589423
  var valid_589424 = query.getOrDefault("includeInactive")
  valid_589424 = validateParameter(valid_589424, JBool, required = false, default = nil)
  if valid_589424 != nil:
    section.add "includeInactive", valid_589424
  var valid_589425 = query.getOrDefault("oauth_token")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "oauth_token", valid_589425
  var valid_589426 = query.getOrDefault("userIp")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "userIp", valid_589426
  var valid_589427 = query.getOrDefault("maxResults")
  valid_589427 = validateParameter(valid_589427, JInt, required = false, default = nil)
  if valid_589427 != nil:
    section.add "maxResults", valid_589427
  var valid_589428 = query.getOrDefault("key")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = nil)
  if valid_589428 != nil:
    section.add "key", valid_589428
  var valid_589429 = query.getOrDefault("prettyPrint")
  valid_589429 = validateParameter(valid_589429, JBool, required = false,
                                 default = newJBool(true))
  if valid_589429 != nil:
    section.add "prettyPrint", valid_589429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589430: Call_AdsenseCustomchannelsAdunitsList_589415;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_589430.validator(path, query, header, formData, body)
  let scheme = call_589430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589430.url(scheme.get, call_589430.host, call_589430.base,
                         call_589430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589430, url, valid)

proc call*(call_589431: Call_AdsenseCustomchannelsAdunitsList_589415;
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
  var path_589432 = newJObject()
  var query_589433 = newJObject()
  add(query_589433, "fields", newJString(fields))
  add(query_589433, "pageToken", newJString(pageToken))
  add(query_589433, "quotaUser", newJString(quotaUser))
  add(query_589433, "alt", newJString(alt))
  add(query_589433, "includeInactive", newJBool(includeInactive))
  add(query_589433, "oauth_token", newJString(oauthToken))
  add(path_589432, "customChannelId", newJString(customChannelId))
  add(query_589433, "userIp", newJString(userIp))
  add(query_589433, "maxResults", newJInt(maxResults))
  add(query_589433, "key", newJString(key))
  add(path_589432, "adClientId", newJString(adClientId))
  add(query_589433, "prettyPrint", newJBool(prettyPrint))
  result = call_589431.call(path_589432, query_589433, nil, nil, nil)

var adsenseCustomchannelsAdunitsList* = Call_AdsenseCustomchannelsAdunitsList_589415(
    name: "adsenseCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseCustomchannelsAdunitsList_589416,
    base: "/adsense/v1.3", url: url_AdsenseCustomchannelsAdunitsList_589417,
    schemes: {Scheme.Https})
type
  Call_AdsenseUrlchannelsList_589434 = ref object of OpenApiRestCall_588457
proc url_AdsenseUrlchannelsList_589436(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseUrlchannelsList_589435(path: JsonNode; query: JsonNode;
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
  var valid_589437 = path.getOrDefault("adClientId")
  valid_589437 = validateParameter(valid_589437, JString, required = true,
                                 default = nil)
  if valid_589437 != nil:
    section.add "adClientId", valid_589437
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
  var valid_589438 = query.getOrDefault("fields")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "fields", valid_589438
  var valid_589439 = query.getOrDefault("pageToken")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "pageToken", valid_589439
  var valid_589440 = query.getOrDefault("quotaUser")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "quotaUser", valid_589440
  var valid_589441 = query.getOrDefault("alt")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = newJString("json"))
  if valid_589441 != nil:
    section.add "alt", valid_589441
  var valid_589442 = query.getOrDefault("oauth_token")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "oauth_token", valid_589442
  var valid_589443 = query.getOrDefault("userIp")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "userIp", valid_589443
  var valid_589444 = query.getOrDefault("maxResults")
  valid_589444 = validateParameter(valid_589444, JInt, required = false, default = nil)
  if valid_589444 != nil:
    section.add "maxResults", valid_589444
  var valid_589445 = query.getOrDefault("key")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "key", valid_589445
  var valid_589446 = query.getOrDefault("prettyPrint")
  valid_589446 = validateParameter(valid_589446, JBool, required = false,
                                 default = newJBool(true))
  if valid_589446 != nil:
    section.add "prettyPrint", valid_589446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589447: Call_AdsenseUrlchannelsList_589434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_589447.validator(path, query, header, formData, body)
  let scheme = call_589447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589447.url(scheme.get, call_589447.host, call_589447.base,
                         call_589447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589447, url, valid)

proc call*(call_589448: Call_AdsenseUrlchannelsList_589434; adClientId: string;
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
  var path_589449 = newJObject()
  var query_589450 = newJObject()
  add(query_589450, "fields", newJString(fields))
  add(query_589450, "pageToken", newJString(pageToken))
  add(query_589450, "quotaUser", newJString(quotaUser))
  add(query_589450, "alt", newJString(alt))
  add(query_589450, "oauth_token", newJString(oauthToken))
  add(query_589450, "userIp", newJString(userIp))
  add(query_589450, "maxResults", newJInt(maxResults))
  add(query_589450, "key", newJString(key))
  add(path_589449, "adClientId", newJString(adClientId))
  add(query_589450, "prettyPrint", newJBool(prettyPrint))
  result = call_589448.call(path_589449, query_589450, nil, nil, nil)

var adsenseUrlchannelsList* = Call_AdsenseUrlchannelsList_589434(
    name: "adsenseUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseUrlchannelsList_589435, base: "/adsense/v1.3",
    url: url_AdsenseUrlchannelsList_589436, schemes: {Scheme.Https})
type
  Call_AdsenseAlertsList_589451 = ref object of OpenApiRestCall_588457
proc url_AdsenseAlertsList_589453(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAlertsList_589452(path: JsonNode; query: JsonNode;
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
  var valid_589454 = query.getOrDefault("locale")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "locale", valid_589454
  var valid_589455 = query.getOrDefault("fields")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "fields", valid_589455
  var valid_589456 = query.getOrDefault("quotaUser")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "quotaUser", valid_589456
  var valid_589457 = query.getOrDefault("alt")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = newJString("json"))
  if valid_589457 != nil:
    section.add "alt", valid_589457
  var valid_589458 = query.getOrDefault("oauth_token")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "oauth_token", valid_589458
  var valid_589459 = query.getOrDefault("userIp")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "userIp", valid_589459
  var valid_589460 = query.getOrDefault("key")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "key", valid_589460
  var valid_589461 = query.getOrDefault("prettyPrint")
  valid_589461 = validateParameter(valid_589461, JBool, required = false,
                                 default = newJBool(true))
  if valid_589461 != nil:
    section.add "prettyPrint", valid_589461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589462: Call_AdsenseAlertsList_589451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for this AdSense account.
  ## 
  let valid = call_589462.validator(path, query, header, formData, body)
  let scheme = call_589462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589462.url(scheme.get, call_589462.host, call_589462.base,
                         call_589462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589462, url, valid)

proc call*(call_589463: Call_AdsenseAlertsList_589451; locale: string = "";
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
  var query_589464 = newJObject()
  add(query_589464, "locale", newJString(locale))
  add(query_589464, "fields", newJString(fields))
  add(query_589464, "quotaUser", newJString(quotaUser))
  add(query_589464, "alt", newJString(alt))
  add(query_589464, "oauth_token", newJString(oauthToken))
  add(query_589464, "userIp", newJString(userIp))
  add(query_589464, "key", newJString(key))
  add(query_589464, "prettyPrint", newJBool(prettyPrint))
  result = call_589463.call(nil, query_589464, nil, nil, nil)

var adsenseAlertsList* = Call_AdsenseAlertsList_589451(name: "adsenseAlertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/alerts",
    validator: validate_AdsenseAlertsList_589452, base: "/adsense/v1.3",
    url: url_AdsenseAlertsList_589453, schemes: {Scheme.Https})
type
  Call_AdsenseMetadataDimensionsList_589465 = ref object of OpenApiRestCall_588457
proc url_AdsenseMetadataDimensionsList_589467(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseMetadataDimensionsList_589466(path: JsonNode; query: JsonNode;
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
  var valid_589468 = query.getOrDefault("fields")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "fields", valid_589468
  var valid_589469 = query.getOrDefault("quotaUser")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "quotaUser", valid_589469
  var valid_589470 = query.getOrDefault("alt")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = newJString("json"))
  if valid_589470 != nil:
    section.add "alt", valid_589470
  var valid_589471 = query.getOrDefault("oauth_token")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "oauth_token", valid_589471
  var valid_589472 = query.getOrDefault("userIp")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "userIp", valid_589472
  var valid_589473 = query.getOrDefault("key")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "key", valid_589473
  var valid_589474 = query.getOrDefault("prettyPrint")
  valid_589474 = validateParameter(valid_589474, JBool, required = false,
                                 default = newJBool(true))
  if valid_589474 != nil:
    section.add "prettyPrint", valid_589474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589475: Call_AdsenseMetadataDimensionsList_589465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdSense account.
  ## 
  let valid = call_589475.validator(path, query, header, formData, body)
  let scheme = call_589475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589475.url(scheme.get, call_589475.host, call_589475.base,
                         call_589475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589475, url, valid)

proc call*(call_589476: Call_AdsenseMetadataDimensionsList_589465;
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
  var query_589477 = newJObject()
  add(query_589477, "fields", newJString(fields))
  add(query_589477, "quotaUser", newJString(quotaUser))
  add(query_589477, "alt", newJString(alt))
  add(query_589477, "oauth_token", newJString(oauthToken))
  add(query_589477, "userIp", newJString(userIp))
  add(query_589477, "key", newJString(key))
  add(query_589477, "prettyPrint", newJBool(prettyPrint))
  result = call_589476.call(nil, query_589477, nil, nil, nil)

var adsenseMetadataDimensionsList* = Call_AdsenseMetadataDimensionsList_589465(
    name: "adsenseMetadataDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/dimensions",
    validator: validate_AdsenseMetadataDimensionsList_589466,
    base: "/adsense/v1.3", url: url_AdsenseMetadataDimensionsList_589467,
    schemes: {Scheme.Https})
type
  Call_AdsenseMetadataMetricsList_589478 = ref object of OpenApiRestCall_588457
proc url_AdsenseMetadataMetricsList_589480(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseMetadataMetricsList_589479(path: JsonNode; query: JsonNode;
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
  var valid_589481 = query.getOrDefault("fields")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "fields", valid_589481
  var valid_589482 = query.getOrDefault("quotaUser")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "quotaUser", valid_589482
  var valid_589483 = query.getOrDefault("alt")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = newJString("json"))
  if valid_589483 != nil:
    section.add "alt", valid_589483
  var valid_589484 = query.getOrDefault("oauth_token")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "oauth_token", valid_589484
  var valid_589485 = query.getOrDefault("userIp")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "userIp", valid_589485
  var valid_589486 = query.getOrDefault("key")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "key", valid_589486
  var valid_589487 = query.getOrDefault("prettyPrint")
  valid_589487 = validateParameter(valid_589487, JBool, required = false,
                                 default = newJBool(true))
  if valid_589487 != nil:
    section.add "prettyPrint", valid_589487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589488: Call_AdsenseMetadataMetricsList_589478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdSense account.
  ## 
  let valid = call_589488.validator(path, query, header, formData, body)
  let scheme = call_589488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589488.url(scheme.get, call_589488.host, call_589488.base,
                         call_589488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589488, url, valid)

proc call*(call_589489: Call_AdsenseMetadataMetricsList_589478;
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
  var query_589490 = newJObject()
  add(query_589490, "fields", newJString(fields))
  add(query_589490, "quotaUser", newJString(quotaUser))
  add(query_589490, "alt", newJString(alt))
  add(query_589490, "oauth_token", newJString(oauthToken))
  add(query_589490, "userIp", newJString(userIp))
  add(query_589490, "key", newJString(key))
  add(query_589490, "prettyPrint", newJBool(prettyPrint))
  result = call_589489.call(nil, query_589490, nil, nil, nil)

var adsenseMetadataMetricsList* = Call_AdsenseMetadataMetricsList_589478(
    name: "adsenseMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/metrics",
    validator: validate_AdsenseMetadataMetricsList_589479, base: "/adsense/v1.3",
    url: url_AdsenseMetadataMetricsList_589480, schemes: {Scheme.Https})
type
  Call_AdsenseReportsGenerate_589491 = ref object of OpenApiRestCall_588457
proc url_AdsenseReportsGenerate_589493(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseReportsGenerate_589492(path: JsonNode; query: JsonNode;
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
  var valid_589494 = query.getOrDefault("useTimezoneReporting")
  valid_589494 = validateParameter(valid_589494, JBool, required = false, default = nil)
  if valid_589494 != nil:
    section.add "useTimezoneReporting", valid_589494
  var valid_589495 = query.getOrDefault("locale")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "locale", valid_589495
  var valid_589496 = query.getOrDefault("fields")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "fields", valid_589496
  var valid_589497 = query.getOrDefault("quotaUser")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "quotaUser", valid_589497
  var valid_589498 = query.getOrDefault("alt")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = newJString("json"))
  if valid_589498 != nil:
    section.add "alt", valid_589498
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_589499 = query.getOrDefault("endDate")
  valid_589499 = validateParameter(valid_589499, JString, required = true,
                                 default = nil)
  if valid_589499 != nil:
    section.add "endDate", valid_589499
  var valid_589500 = query.getOrDefault("currency")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "currency", valid_589500
  var valid_589501 = query.getOrDefault("startDate")
  valid_589501 = validateParameter(valid_589501, JString, required = true,
                                 default = nil)
  if valid_589501 != nil:
    section.add "startDate", valid_589501
  var valid_589502 = query.getOrDefault("sort")
  valid_589502 = validateParameter(valid_589502, JArray, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "sort", valid_589502
  var valid_589503 = query.getOrDefault("oauth_token")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "oauth_token", valid_589503
  var valid_589504 = query.getOrDefault("accountId")
  valid_589504 = validateParameter(valid_589504, JArray, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "accountId", valid_589504
  var valid_589505 = query.getOrDefault("userIp")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "userIp", valid_589505
  var valid_589506 = query.getOrDefault("maxResults")
  valid_589506 = validateParameter(valid_589506, JInt, required = false, default = nil)
  if valid_589506 != nil:
    section.add "maxResults", valid_589506
  var valid_589507 = query.getOrDefault("key")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "key", valid_589507
  var valid_589508 = query.getOrDefault("metric")
  valid_589508 = validateParameter(valid_589508, JArray, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "metric", valid_589508
  var valid_589509 = query.getOrDefault("prettyPrint")
  valid_589509 = validateParameter(valid_589509, JBool, required = false,
                                 default = newJBool(true))
  if valid_589509 != nil:
    section.add "prettyPrint", valid_589509
  var valid_589510 = query.getOrDefault("dimension")
  valid_589510 = validateParameter(valid_589510, JArray, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "dimension", valid_589510
  var valid_589511 = query.getOrDefault("filter")
  valid_589511 = validateParameter(valid_589511, JArray, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "filter", valid_589511
  var valid_589512 = query.getOrDefault("startIndex")
  valid_589512 = validateParameter(valid_589512, JInt, required = false, default = nil)
  if valid_589512 != nil:
    section.add "startIndex", valid_589512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589513: Call_AdsenseReportsGenerate_589491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_589513.validator(path, query, header, formData, body)
  let scheme = call_589513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589513.url(scheme.get, call_589513.host, call_589513.base,
                         call_589513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589513, url, valid)

proc call*(call_589514: Call_AdsenseReportsGenerate_589491; endDate: string;
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
  var query_589515 = newJObject()
  add(query_589515, "useTimezoneReporting", newJBool(useTimezoneReporting))
  add(query_589515, "locale", newJString(locale))
  add(query_589515, "fields", newJString(fields))
  add(query_589515, "quotaUser", newJString(quotaUser))
  add(query_589515, "alt", newJString(alt))
  add(query_589515, "endDate", newJString(endDate))
  add(query_589515, "currency", newJString(currency))
  add(query_589515, "startDate", newJString(startDate))
  if sort != nil:
    query_589515.add "sort", sort
  add(query_589515, "oauth_token", newJString(oauthToken))
  if accountId != nil:
    query_589515.add "accountId", accountId
  add(query_589515, "userIp", newJString(userIp))
  add(query_589515, "maxResults", newJInt(maxResults))
  add(query_589515, "key", newJString(key))
  if metric != nil:
    query_589515.add "metric", metric
  add(query_589515, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_589515.add "dimension", dimension
  if filter != nil:
    query_589515.add "filter", filter
  add(query_589515, "startIndex", newJInt(startIndex))
  result = call_589514.call(nil, query_589515, nil, nil, nil)

var adsenseReportsGenerate* = Call_AdsenseReportsGenerate_589491(
    name: "adsenseReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsenseReportsGenerate_589492, base: "/adsense/v1.3",
    url: url_AdsenseReportsGenerate_589493, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedList_589516 = ref object of OpenApiRestCall_588457
proc url_AdsenseReportsSavedList_589518(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseReportsSavedList_589517(path: JsonNode; query: JsonNode;
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
  var valid_589519 = query.getOrDefault("fields")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "fields", valid_589519
  var valid_589520 = query.getOrDefault("pageToken")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "pageToken", valid_589520
  var valid_589521 = query.getOrDefault("quotaUser")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "quotaUser", valid_589521
  var valid_589522 = query.getOrDefault("alt")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = newJString("json"))
  if valid_589522 != nil:
    section.add "alt", valid_589522
  var valid_589523 = query.getOrDefault("oauth_token")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "oauth_token", valid_589523
  var valid_589524 = query.getOrDefault("userIp")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "userIp", valid_589524
  var valid_589525 = query.getOrDefault("maxResults")
  valid_589525 = validateParameter(valid_589525, JInt, required = false, default = nil)
  if valid_589525 != nil:
    section.add "maxResults", valid_589525
  var valid_589526 = query.getOrDefault("key")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "key", valid_589526
  var valid_589527 = query.getOrDefault("prettyPrint")
  valid_589527 = validateParameter(valid_589527, JBool, required = false,
                                 default = newJBool(true))
  if valid_589527 != nil:
    section.add "prettyPrint", valid_589527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589528: Call_AdsenseReportsSavedList_589516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved reports in this AdSense account.
  ## 
  let valid = call_589528.validator(path, query, header, formData, body)
  let scheme = call_589528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589528.url(scheme.get, call_589528.host, call_589528.base,
                         call_589528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589528, url, valid)

proc call*(call_589529: Call_AdsenseReportsSavedList_589516; fields: string = "";
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
  var query_589530 = newJObject()
  add(query_589530, "fields", newJString(fields))
  add(query_589530, "pageToken", newJString(pageToken))
  add(query_589530, "quotaUser", newJString(quotaUser))
  add(query_589530, "alt", newJString(alt))
  add(query_589530, "oauth_token", newJString(oauthToken))
  add(query_589530, "userIp", newJString(userIp))
  add(query_589530, "maxResults", newJInt(maxResults))
  add(query_589530, "key", newJString(key))
  add(query_589530, "prettyPrint", newJBool(prettyPrint))
  result = call_589529.call(nil, query_589530, nil, nil, nil)

var adsenseReportsSavedList* = Call_AdsenseReportsSavedList_589516(
    name: "adsenseReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdsenseReportsSavedList_589517, base: "/adsense/v1.3",
    url: url_AdsenseReportsSavedList_589518, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedGenerate_589531 = ref object of OpenApiRestCall_588457
proc url_AdsenseReportsSavedGenerate_589533(protocol: Scheme; host: string;
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

proc validate_AdsenseReportsSavedGenerate_589532(path: JsonNode; query: JsonNode;
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
  var valid_589534 = path.getOrDefault("savedReportId")
  valid_589534 = validateParameter(valid_589534, JString, required = true,
                                 default = nil)
  if valid_589534 != nil:
    section.add "savedReportId", valid_589534
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
  var valid_589535 = query.getOrDefault("locale")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = nil)
  if valid_589535 != nil:
    section.add "locale", valid_589535
  var valid_589536 = query.getOrDefault("fields")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "fields", valid_589536
  var valid_589537 = query.getOrDefault("quotaUser")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "quotaUser", valid_589537
  var valid_589538 = query.getOrDefault("alt")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = newJString("json"))
  if valid_589538 != nil:
    section.add "alt", valid_589538
  var valid_589539 = query.getOrDefault("oauth_token")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "oauth_token", valid_589539
  var valid_589540 = query.getOrDefault("userIp")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "userIp", valid_589540
  var valid_589541 = query.getOrDefault("maxResults")
  valid_589541 = validateParameter(valid_589541, JInt, required = false, default = nil)
  if valid_589541 != nil:
    section.add "maxResults", valid_589541
  var valid_589542 = query.getOrDefault("key")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "key", valid_589542
  var valid_589543 = query.getOrDefault("prettyPrint")
  valid_589543 = validateParameter(valid_589543, JBool, required = false,
                                 default = newJBool(true))
  if valid_589543 != nil:
    section.add "prettyPrint", valid_589543
  var valid_589544 = query.getOrDefault("startIndex")
  valid_589544 = validateParameter(valid_589544, JInt, required = false, default = nil)
  if valid_589544 != nil:
    section.add "startIndex", valid_589544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589545: Call_AdsenseReportsSavedGenerate_589531; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_589545.validator(path, query, header, formData, body)
  let scheme = call_589545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589545.url(scheme.get, call_589545.host, call_589545.base,
                         call_589545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589545, url, valid)

proc call*(call_589546: Call_AdsenseReportsSavedGenerate_589531;
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
  var path_589547 = newJObject()
  var query_589548 = newJObject()
  add(query_589548, "locale", newJString(locale))
  add(query_589548, "fields", newJString(fields))
  add(query_589548, "quotaUser", newJString(quotaUser))
  add(query_589548, "alt", newJString(alt))
  add(query_589548, "oauth_token", newJString(oauthToken))
  add(query_589548, "userIp", newJString(userIp))
  add(path_589547, "savedReportId", newJString(savedReportId))
  add(query_589548, "maxResults", newJInt(maxResults))
  add(query_589548, "key", newJString(key))
  add(query_589548, "prettyPrint", newJBool(prettyPrint))
  add(query_589548, "startIndex", newJInt(startIndex))
  result = call_589546.call(path_589547, query_589548, nil, nil, nil)

var adsenseReportsSavedGenerate* = Call_AdsenseReportsSavedGenerate_589531(
    name: "adsenseReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdsenseReportsSavedGenerate_589532, base: "/adsense/v1.3",
    url: url_AdsenseReportsSavedGenerate_589533, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesList_589549 = ref object of OpenApiRestCall_588457
proc url_AdsenseSavedadstylesList_589551(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseSavedadstylesList_589550(path: JsonNode; query: JsonNode;
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
  var valid_589552 = query.getOrDefault("fields")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "fields", valid_589552
  var valid_589553 = query.getOrDefault("pageToken")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "pageToken", valid_589553
  var valid_589554 = query.getOrDefault("quotaUser")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = nil)
  if valid_589554 != nil:
    section.add "quotaUser", valid_589554
  var valid_589555 = query.getOrDefault("alt")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = newJString("json"))
  if valid_589555 != nil:
    section.add "alt", valid_589555
  var valid_589556 = query.getOrDefault("oauth_token")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = nil)
  if valid_589556 != nil:
    section.add "oauth_token", valid_589556
  var valid_589557 = query.getOrDefault("userIp")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "userIp", valid_589557
  var valid_589558 = query.getOrDefault("maxResults")
  valid_589558 = validateParameter(valid_589558, JInt, required = false, default = nil)
  if valid_589558 != nil:
    section.add "maxResults", valid_589558
  var valid_589559 = query.getOrDefault("key")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "key", valid_589559
  var valid_589560 = query.getOrDefault("prettyPrint")
  valid_589560 = validateParameter(valid_589560, JBool, required = false,
                                 default = newJBool(true))
  if valid_589560 != nil:
    section.add "prettyPrint", valid_589560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589561: Call_AdsenseSavedadstylesList_589549; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved ad styles in the user's account.
  ## 
  let valid = call_589561.validator(path, query, header, formData, body)
  let scheme = call_589561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589561.url(scheme.get, call_589561.host, call_589561.base,
                         call_589561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589561, url, valid)

proc call*(call_589562: Call_AdsenseSavedadstylesList_589549; fields: string = "";
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
  var query_589563 = newJObject()
  add(query_589563, "fields", newJString(fields))
  add(query_589563, "pageToken", newJString(pageToken))
  add(query_589563, "quotaUser", newJString(quotaUser))
  add(query_589563, "alt", newJString(alt))
  add(query_589563, "oauth_token", newJString(oauthToken))
  add(query_589563, "userIp", newJString(userIp))
  add(query_589563, "maxResults", newJInt(maxResults))
  add(query_589563, "key", newJString(key))
  add(query_589563, "prettyPrint", newJBool(prettyPrint))
  result = call_589562.call(nil, query_589563, nil, nil, nil)

var adsenseSavedadstylesList* = Call_AdsenseSavedadstylesList_589549(
    name: "adsenseSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles",
    validator: validate_AdsenseSavedadstylesList_589550, base: "/adsense/v1.3",
    url: url_AdsenseSavedadstylesList_589551, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesGet_589564 = ref object of OpenApiRestCall_588457
proc url_AdsenseSavedadstylesGet_589566(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseSavedadstylesGet_589565(path: JsonNode; query: JsonNode;
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
  var valid_589567 = path.getOrDefault("savedAdStyleId")
  valid_589567 = validateParameter(valid_589567, JString, required = true,
                                 default = nil)
  if valid_589567 != nil:
    section.add "savedAdStyleId", valid_589567
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
  var valid_589568 = query.getOrDefault("fields")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = nil)
  if valid_589568 != nil:
    section.add "fields", valid_589568
  var valid_589569 = query.getOrDefault("quotaUser")
  valid_589569 = validateParameter(valid_589569, JString, required = false,
                                 default = nil)
  if valid_589569 != nil:
    section.add "quotaUser", valid_589569
  var valid_589570 = query.getOrDefault("alt")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = newJString("json"))
  if valid_589570 != nil:
    section.add "alt", valid_589570
  var valid_589571 = query.getOrDefault("oauth_token")
  valid_589571 = validateParameter(valid_589571, JString, required = false,
                                 default = nil)
  if valid_589571 != nil:
    section.add "oauth_token", valid_589571
  var valid_589572 = query.getOrDefault("userIp")
  valid_589572 = validateParameter(valid_589572, JString, required = false,
                                 default = nil)
  if valid_589572 != nil:
    section.add "userIp", valid_589572
  var valid_589573 = query.getOrDefault("key")
  valid_589573 = validateParameter(valid_589573, JString, required = false,
                                 default = nil)
  if valid_589573 != nil:
    section.add "key", valid_589573
  var valid_589574 = query.getOrDefault("prettyPrint")
  valid_589574 = validateParameter(valid_589574, JBool, required = false,
                                 default = newJBool(true))
  if valid_589574 != nil:
    section.add "prettyPrint", valid_589574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589575: Call_AdsenseSavedadstylesGet_589564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific saved ad style from the user's account.
  ## 
  let valid = call_589575.validator(path, query, header, formData, body)
  let scheme = call_589575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589575.url(scheme.get, call_589575.host, call_589575.base,
                         call_589575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589575, url, valid)

proc call*(call_589576: Call_AdsenseSavedadstylesGet_589564;
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
  var path_589577 = newJObject()
  var query_589578 = newJObject()
  add(query_589578, "fields", newJString(fields))
  add(query_589578, "quotaUser", newJString(quotaUser))
  add(query_589578, "alt", newJString(alt))
  add(query_589578, "oauth_token", newJString(oauthToken))
  add(path_589577, "savedAdStyleId", newJString(savedAdStyleId))
  add(query_589578, "userIp", newJString(userIp))
  add(query_589578, "key", newJString(key))
  add(query_589578, "prettyPrint", newJBool(prettyPrint))
  result = call_589576.call(path_589577, query_589578, nil, nil, nil)

var adsenseSavedadstylesGet* = Call_AdsenseSavedadstylesGet_589564(
    name: "adsenseSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseSavedadstylesGet_589565, base: "/adsense/v1.3",
    url: url_AdsenseSavedadstylesGet_589566, schemes: {Scheme.Https})
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
