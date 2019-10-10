
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: AdSense Host
## version: v4.1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Generates performance reports, generates ad codes, and provides publisher management capabilities for AdSense Hosts.
## 
## https://developers.google.com/adsense/host/
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
  gcpServiceName = "adsensehost"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdsensehostAccountsList_588726 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsList_588728(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAccountsList_588727(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List hosted accounts associated with this AdSense account by ad client id.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   filterAdClientId: JArray (required)
  ##                   : Ad clients to list accounts for.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
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
  assert query != nil,
        "query argument is necessary due to required `filterAdClientId` field"
  var valid_588841 = query.getOrDefault("filterAdClientId")
  valid_588841 = validateParameter(valid_588841, JArray, required = true, default = nil)
  if valid_588841 != nil:
    section.add "filterAdClientId", valid_588841
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
  var valid_588859 = query.getOrDefault("key")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "key", valid_588859
  var valid_588860 = query.getOrDefault("prettyPrint")
  valid_588860 = validateParameter(valid_588860, JBool, required = false,
                                 default = newJBool(true))
  if valid_588860 != nil:
    section.add "prettyPrint", valid_588860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588883: Call_AdsensehostAccountsList_588726; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List hosted accounts associated with this AdSense account by ad client id.
  ## 
  let valid = call_588883.validator(path, query, header, formData, body)
  let scheme = call_588883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588883.url(scheme.get, call_588883.host, call_588883.base,
                         call_588883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588883, url, valid)

proc call*(call_588954: Call_AdsensehostAccountsList_588726;
          filterAdClientId: JsonNode; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsList
  ## List hosted accounts associated with this AdSense account by ad client id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   filterAdClientId: JArray (required)
  ##                   : Ad clients to list accounts for.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588955 = newJObject()
  add(query_588955, "fields", newJString(fields))
  if filterAdClientId != nil:
    query_588955.add "filterAdClientId", filterAdClientId
  add(query_588955, "quotaUser", newJString(quotaUser))
  add(query_588955, "alt", newJString(alt))
  add(query_588955, "oauth_token", newJString(oauthToken))
  add(query_588955, "userIp", newJString(userIp))
  add(query_588955, "key", newJString(key))
  add(query_588955, "prettyPrint", newJBool(prettyPrint))
  result = call_588954.call(nil, query_588955, nil, nil, nil)

var adsensehostAccountsList* = Call_AdsensehostAccountsList_588726(
    name: "adsensehostAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdsensehostAccountsList_588727, base: "/adsensehost/v4.1",
    url: url_AdsensehostAccountsList_588728, schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsGet_588995 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsGet_588997(protocol: Scheme; host: string; base: string;
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

proc validate_AdsensehostAccountsGet_588996(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about the selected associated AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589012 = path.getOrDefault("accountId")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "accountId", valid_589012
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589013 = query.getOrDefault("fields")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "fields", valid_589013
  var valid_589014 = query.getOrDefault("quotaUser")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "quotaUser", valid_589014
  var valid_589015 = query.getOrDefault("alt")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("json"))
  if valid_589015 != nil:
    section.add "alt", valid_589015
  var valid_589016 = query.getOrDefault("oauth_token")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "oauth_token", valid_589016
  var valid_589017 = query.getOrDefault("userIp")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "userIp", valid_589017
  var valid_589018 = query.getOrDefault("key")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "key", valid_589018
  var valid_589019 = query.getOrDefault("prettyPrint")
  valid_589019 = validateParameter(valid_589019, JBool, required = false,
                                 default = newJBool(true))
  if valid_589019 != nil:
    section.add "prettyPrint", valid_589019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589020: Call_AdsensehostAccountsGet_588995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected associated AdSense account.
  ## 
  let valid = call_589020.validator(path, query, header, formData, body)
  let scheme = call_589020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589020.url(scheme.get, call_589020.host, call_589020.base,
                         call_589020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589020, url, valid)

proc call*(call_589021: Call_AdsensehostAccountsGet_588995; accountId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsGet
  ## Get information about the selected associated AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to get information about.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589022 = newJObject()
  var query_589023 = newJObject()
  add(query_589023, "fields", newJString(fields))
  add(query_589023, "quotaUser", newJString(quotaUser))
  add(query_589023, "alt", newJString(alt))
  add(query_589023, "oauth_token", newJString(oauthToken))
  add(path_589022, "accountId", newJString(accountId))
  add(query_589023, "userIp", newJString(userIp))
  add(query_589023, "key", newJString(key))
  add(query_589023, "prettyPrint", newJBool(prettyPrint))
  result = call_589021.call(path_589022, query_589023, nil, nil, nil)

var adsensehostAccountsGet* = Call_AdsensehostAccountsGet_588995(
    name: "adsensehostAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdsensehostAccountsGet_588996, base: "/adsensehost/v4.1",
    url: url_AdsensehostAccountsGet_588997, schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdclientsList_589024 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsAdclientsList_589026(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdclientsList_589025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all hosted ad clients in the specified hosted account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to list ad clients.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589027 = path.getOrDefault("accountId")
  valid_589027 = validateParameter(valid_589027, JString, required = true,
                                 default = nil)
  if valid_589027 != nil:
    section.add "accountId", valid_589027
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589028 = query.getOrDefault("fields")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "fields", valid_589028
  var valid_589029 = query.getOrDefault("pageToken")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "pageToken", valid_589029
  var valid_589030 = query.getOrDefault("quotaUser")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "quotaUser", valid_589030
  var valid_589031 = query.getOrDefault("alt")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("json"))
  if valid_589031 != nil:
    section.add "alt", valid_589031
  var valid_589032 = query.getOrDefault("oauth_token")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "oauth_token", valid_589032
  var valid_589033 = query.getOrDefault("userIp")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "userIp", valid_589033
  var valid_589034 = query.getOrDefault("maxResults")
  valid_589034 = validateParameter(valid_589034, JInt, required = false, default = nil)
  if valid_589034 != nil:
    section.add "maxResults", valid_589034
  var valid_589035 = query.getOrDefault("key")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "key", valid_589035
  var valid_589036 = query.getOrDefault("prettyPrint")
  valid_589036 = validateParameter(valid_589036, JBool, required = false,
                                 default = newJBool(true))
  if valid_589036 != nil:
    section.add "prettyPrint", valid_589036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589037: Call_AdsensehostAccountsAdclientsList_589024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all hosted ad clients in the specified hosted account.
  ## 
  let valid = call_589037.validator(path, query, header, formData, body)
  let scheme = call_589037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589037.url(scheme.get, call_589037.host, call_589037.base,
                         call_589037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589037, url, valid)

proc call*(call_589038: Call_AdsensehostAccountsAdclientsList_589024;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdclientsList
  ## List all hosted ad clients in the specified hosted account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to list ad clients.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589039 = newJObject()
  var query_589040 = newJObject()
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "pageToken", newJString(pageToken))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(path_589039, "accountId", newJString(accountId))
  add(query_589040, "userIp", newJString(userIp))
  add(query_589040, "maxResults", newJInt(maxResults))
  add(query_589040, "key", newJString(key))
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  result = call_589038.call(path_589039, query_589040, nil, nil, nil)

var adsensehostAccountsAdclientsList* = Call_AdsensehostAccountsAdclientsList_589024(
    name: "adsensehostAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdsensehostAccountsAdclientsList_589025,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdclientsList_589026,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdclientsGet_589041 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsAdclientsGet_589043(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "adClientId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdclientsGet_589042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about one of the ad clients in the specified publisher's AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589044 = path.getOrDefault("accountId")
  valid_589044 = validateParameter(valid_589044, JString, required = true,
                                 default = nil)
  if valid_589044 != nil:
    section.add "accountId", valid_589044
  var valid_589045 = path.getOrDefault("adClientId")
  valid_589045 = validateParameter(valid_589045, JString, required = true,
                                 default = nil)
  if valid_589045 != nil:
    section.add "adClientId", valid_589045
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589046 = query.getOrDefault("fields")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "fields", valid_589046
  var valid_589047 = query.getOrDefault("quotaUser")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "quotaUser", valid_589047
  var valid_589048 = query.getOrDefault("alt")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("json"))
  if valid_589048 != nil:
    section.add "alt", valid_589048
  var valid_589049 = query.getOrDefault("oauth_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "oauth_token", valid_589049
  var valid_589050 = query.getOrDefault("userIp")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "userIp", valid_589050
  var valid_589051 = query.getOrDefault("key")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "key", valid_589051
  var valid_589052 = query.getOrDefault("prettyPrint")
  valid_589052 = validateParameter(valid_589052, JBool, required = false,
                                 default = newJBool(true))
  if valid_589052 != nil:
    section.add "prettyPrint", valid_589052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589053: Call_AdsensehostAccountsAdclientsGet_589041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about one of the ad clients in the specified publisher's AdSense account.
  ## 
  let valid = call_589053.validator(path, query, header, formData, body)
  let scheme = call_589053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589053.url(scheme.get, call_589053.host, call_589053.base,
                         call_589053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589053, url, valid)

proc call*(call_589054: Call_AdsensehostAccountsAdclientsGet_589041;
          accountId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdclientsGet
  ## Get information about one of the ad clients in the specified publisher's AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589055 = newJObject()
  var query_589056 = newJObject()
  add(query_589056, "fields", newJString(fields))
  add(query_589056, "quotaUser", newJString(quotaUser))
  add(query_589056, "alt", newJString(alt))
  add(query_589056, "oauth_token", newJString(oauthToken))
  add(path_589055, "accountId", newJString(accountId))
  add(query_589056, "userIp", newJString(userIp))
  add(query_589056, "key", newJString(key))
  add(path_589055, "adClientId", newJString(adClientId))
  add(query_589056, "prettyPrint", newJBool(prettyPrint))
  result = call_589054.call(path_589055, query_589056, nil, nil, nil)

var adsensehostAccountsAdclientsGet* = Call_AdsensehostAccountsAdclientsGet_589041(
    name: "adsensehostAccountsAdclientsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}",
    validator: validate_AdsensehostAccountsAdclientsGet_589042,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdclientsGet_589043,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsUpdate_589076 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsAdunitsUpdate_589078(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsUpdate_589077(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the supplied ad unit in the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589079 = path.getOrDefault("accountId")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "accountId", valid_589079
  var valid_589080 = path.getOrDefault("adClientId")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "adClientId", valid_589080
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589081 = query.getOrDefault("fields")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "fields", valid_589081
  var valid_589082 = query.getOrDefault("quotaUser")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "quotaUser", valid_589082
  var valid_589083 = query.getOrDefault("alt")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = newJString("json"))
  if valid_589083 != nil:
    section.add "alt", valid_589083
  var valid_589084 = query.getOrDefault("oauth_token")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "oauth_token", valid_589084
  var valid_589085 = query.getOrDefault("userIp")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "userIp", valid_589085
  var valid_589086 = query.getOrDefault("key")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "key", valid_589086
  var valid_589087 = query.getOrDefault("prettyPrint")
  valid_589087 = validateParameter(valid_589087, JBool, required = false,
                                 default = newJBool(true))
  if valid_589087 != nil:
    section.add "prettyPrint", valid_589087
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

proc call*(call_589089: Call_AdsensehostAccountsAdunitsUpdate_589076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the supplied ad unit in the specified publisher AdSense account.
  ## 
  let valid = call_589089.validator(path, query, header, formData, body)
  let scheme = call_589089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589089.url(scheme.get, call_589089.host, call_589089.base,
                         call_589089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589089, url, valid)

proc call*(call_589090: Call_AdsensehostAccountsAdunitsUpdate_589076;
          accountId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsUpdate
  ## Update the supplied ad unit in the specified publisher AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589091 = newJObject()
  var query_589092 = newJObject()
  var body_589093 = newJObject()
  add(query_589092, "fields", newJString(fields))
  add(query_589092, "quotaUser", newJString(quotaUser))
  add(query_589092, "alt", newJString(alt))
  add(query_589092, "oauth_token", newJString(oauthToken))
  add(path_589091, "accountId", newJString(accountId))
  add(query_589092, "userIp", newJString(userIp))
  add(query_589092, "key", newJString(key))
  add(path_589091, "adClientId", newJString(adClientId))
  if body != nil:
    body_589093 = body
  add(query_589092, "prettyPrint", newJBool(prettyPrint))
  result = call_589090.call(path_589091, query_589092, nil, nil, body_589093)

var adsensehostAccountsAdunitsUpdate* = Call_AdsensehostAccountsAdunitsUpdate_589076(
    name: "adsensehostAccountsAdunitsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsUpdate_589077,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsUpdate_589078,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsInsert_589094 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsAdunitsInsert_589096(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsInsert_589095(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Insert the supplied ad unit into the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which will contain the ad unit.
  ##   adClientId: JString (required)
  ##             : Ad client into which to insert the ad unit.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589097 = path.getOrDefault("accountId")
  valid_589097 = validateParameter(valid_589097, JString, required = true,
                                 default = nil)
  if valid_589097 != nil:
    section.add "accountId", valid_589097
  var valid_589098 = path.getOrDefault("adClientId")
  valid_589098 = validateParameter(valid_589098, JString, required = true,
                                 default = nil)
  if valid_589098 != nil:
    section.add "adClientId", valid_589098
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589099 = query.getOrDefault("fields")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "fields", valid_589099
  var valid_589100 = query.getOrDefault("quotaUser")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "quotaUser", valid_589100
  var valid_589101 = query.getOrDefault("alt")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("json"))
  if valid_589101 != nil:
    section.add "alt", valid_589101
  var valid_589102 = query.getOrDefault("oauth_token")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "oauth_token", valid_589102
  var valid_589103 = query.getOrDefault("userIp")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "userIp", valid_589103
  var valid_589104 = query.getOrDefault("key")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "key", valid_589104
  var valid_589105 = query.getOrDefault("prettyPrint")
  valid_589105 = validateParameter(valid_589105, JBool, required = false,
                                 default = newJBool(true))
  if valid_589105 != nil:
    section.add "prettyPrint", valid_589105
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

proc call*(call_589107: Call_AdsensehostAccountsAdunitsInsert_589094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert the supplied ad unit into the specified publisher AdSense account.
  ## 
  let valid = call_589107.validator(path, query, header, formData, body)
  let scheme = call_589107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589107.url(scheme.get, call_589107.host, call_589107.base,
                         call_589107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589107, url, valid)

proc call*(call_589108: Call_AdsensehostAccountsAdunitsInsert_589094;
          accountId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsInsert
  ## Insert the supplied ad unit into the specified publisher AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which will contain the ad unit.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client into which to insert the ad unit.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589109 = newJObject()
  var query_589110 = newJObject()
  var body_589111 = newJObject()
  add(query_589110, "fields", newJString(fields))
  add(query_589110, "quotaUser", newJString(quotaUser))
  add(query_589110, "alt", newJString(alt))
  add(query_589110, "oauth_token", newJString(oauthToken))
  add(path_589109, "accountId", newJString(accountId))
  add(query_589110, "userIp", newJString(userIp))
  add(query_589110, "key", newJString(key))
  add(path_589109, "adClientId", newJString(adClientId))
  if body != nil:
    body_589111 = body
  add(query_589110, "prettyPrint", newJBool(prettyPrint))
  result = call_589108.call(path_589109, query_589110, nil, nil, body_589111)

var adsensehostAccountsAdunitsInsert* = Call_AdsensehostAccountsAdunitsInsert_589094(
    name: "adsensehostAccountsAdunitsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsInsert_589095,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsInsert_589096,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsList_589057 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsAdunitsList_589059(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsList_589058(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified publisher's AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client for which to list ad units.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589060 = path.getOrDefault("accountId")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "accountId", valid_589060
  var valid_589061 = path.getOrDefault("adClientId")
  valid_589061 = validateParameter(valid_589061, JString, required = true,
                                 default = nil)
  if valid_589061 != nil:
    section.add "adClientId", valid_589061
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589062 = query.getOrDefault("fields")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "fields", valid_589062
  var valid_589063 = query.getOrDefault("pageToken")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "pageToken", valid_589063
  var valid_589064 = query.getOrDefault("quotaUser")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "quotaUser", valid_589064
  var valid_589065 = query.getOrDefault("alt")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("json"))
  if valid_589065 != nil:
    section.add "alt", valid_589065
  var valid_589066 = query.getOrDefault("includeInactive")
  valid_589066 = validateParameter(valid_589066, JBool, required = false, default = nil)
  if valid_589066 != nil:
    section.add "includeInactive", valid_589066
  var valid_589067 = query.getOrDefault("oauth_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "oauth_token", valid_589067
  var valid_589068 = query.getOrDefault("userIp")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "userIp", valid_589068
  var valid_589069 = query.getOrDefault("maxResults")
  valid_589069 = validateParameter(valid_589069, JInt, required = false, default = nil)
  if valid_589069 != nil:
    section.add "maxResults", valid_589069
  var valid_589070 = query.getOrDefault("key")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "key", valid_589070
  var valid_589071 = query.getOrDefault("prettyPrint")
  valid_589071 = validateParameter(valid_589071, JBool, required = false,
                                 default = newJBool(true))
  if valid_589071 != nil:
    section.add "prettyPrint", valid_589071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589072: Call_AdsensehostAccountsAdunitsList_589057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified publisher's AdSense account.
  ## 
  let valid = call_589072.validator(path, query, header, formData, body)
  let scheme = call_589072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589072.url(scheme.get, call_589072.host, call_589072.base,
                         call_589072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589072, url, valid)

proc call*(call_589073: Call_AdsensehostAccountsAdunitsList_589057;
          accountId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          includeInactive: bool = false; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsList
  ## List all ad units in the specified publisher's AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list ad units.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589074 = newJObject()
  var query_589075 = newJObject()
  add(query_589075, "fields", newJString(fields))
  add(query_589075, "pageToken", newJString(pageToken))
  add(query_589075, "quotaUser", newJString(quotaUser))
  add(query_589075, "alt", newJString(alt))
  add(query_589075, "includeInactive", newJBool(includeInactive))
  add(query_589075, "oauth_token", newJString(oauthToken))
  add(path_589074, "accountId", newJString(accountId))
  add(query_589075, "userIp", newJString(userIp))
  add(query_589075, "maxResults", newJInt(maxResults))
  add(query_589075, "key", newJString(key))
  add(path_589074, "adClientId", newJString(adClientId))
  add(query_589075, "prettyPrint", newJBool(prettyPrint))
  result = call_589073.call(path_589074, query_589075, nil, nil, nil)

var adsensehostAccountsAdunitsList* = Call_AdsensehostAccountsAdunitsList_589057(
    name: "adsensehostAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsList_589058,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsList_589059,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsPatch_589112 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsAdunitsPatch_589114(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsPatch_589113(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the supplied ad unit in the specified publisher AdSense account. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589115 = path.getOrDefault("accountId")
  valid_589115 = validateParameter(valid_589115, JString, required = true,
                                 default = nil)
  if valid_589115 != nil:
    section.add "accountId", valid_589115
  var valid_589116 = path.getOrDefault("adClientId")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "adClientId", valid_589116
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589117 = query.getOrDefault("fields")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "fields", valid_589117
  var valid_589118 = query.getOrDefault("quotaUser")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "quotaUser", valid_589118
  var valid_589119 = query.getOrDefault("alt")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("json"))
  if valid_589119 != nil:
    section.add "alt", valid_589119
  assert query != nil,
        "query argument is necessary due to required `adUnitId` field"
  var valid_589120 = query.getOrDefault("adUnitId")
  valid_589120 = validateParameter(valid_589120, JString, required = true,
                                 default = nil)
  if valid_589120 != nil:
    section.add "adUnitId", valid_589120
  var valid_589121 = query.getOrDefault("oauth_token")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "oauth_token", valid_589121
  var valid_589122 = query.getOrDefault("userIp")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "userIp", valid_589122
  var valid_589123 = query.getOrDefault("key")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "key", valid_589123
  var valid_589124 = query.getOrDefault("prettyPrint")
  valid_589124 = validateParameter(valid_589124, JBool, required = false,
                                 default = newJBool(true))
  if valid_589124 != nil:
    section.add "prettyPrint", valid_589124
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

proc call*(call_589126: Call_AdsensehostAccountsAdunitsPatch_589112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the supplied ad unit in the specified publisher AdSense account. This method supports patch semantics.
  ## 
  let valid = call_589126.validator(path, query, header, formData, body)
  let scheme = call_589126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589126.url(scheme.get, call_589126.host, call_589126.base,
                         call_589126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589126, url, valid)

proc call*(call_589127: Call_AdsensehostAccountsAdunitsPatch_589112;
          adUnitId: string; accountId: string; adClientId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsPatch
  ## Update the supplied ad unit in the specified publisher AdSense account. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   adUnitId: string (required)
  ##           : Ad unit to get.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589128 = newJObject()
  var query_589129 = newJObject()
  var body_589130 = newJObject()
  add(query_589129, "fields", newJString(fields))
  add(query_589129, "quotaUser", newJString(quotaUser))
  add(query_589129, "alt", newJString(alt))
  add(query_589129, "adUnitId", newJString(adUnitId))
  add(query_589129, "oauth_token", newJString(oauthToken))
  add(path_589128, "accountId", newJString(accountId))
  add(query_589129, "userIp", newJString(userIp))
  add(query_589129, "key", newJString(key))
  add(path_589128, "adClientId", newJString(adClientId))
  if body != nil:
    body_589130 = body
  add(query_589129, "prettyPrint", newJBool(prettyPrint))
  result = call_589127.call(path_589128, query_589129, nil, nil, body_589130)

var adsensehostAccountsAdunitsPatch* = Call_AdsensehostAccountsAdunitsPatch_589112(
    name: "adsensehostAccountsAdunitsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsPatch_589113,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsPatch_589114,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsGet_589131 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsAdunitsGet_589133(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsGet_589132(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified host ad unit in this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad unit.
  ##   adClientId: JString (required)
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589134 = path.getOrDefault("accountId")
  valid_589134 = validateParameter(valid_589134, JString, required = true,
                                 default = nil)
  if valid_589134 != nil:
    section.add "accountId", valid_589134
  var valid_589135 = path.getOrDefault("adClientId")
  valid_589135 = validateParameter(valid_589135, JString, required = true,
                                 default = nil)
  if valid_589135 != nil:
    section.add "adClientId", valid_589135
  var valid_589136 = path.getOrDefault("adUnitId")
  valid_589136 = validateParameter(valid_589136, JString, required = true,
                                 default = nil)
  if valid_589136 != nil:
    section.add "adUnitId", valid_589136
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589137 = query.getOrDefault("fields")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "fields", valid_589137
  var valid_589138 = query.getOrDefault("quotaUser")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "quotaUser", valid_589138
  var valid_589139 = query.getOrDefault("alt")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = newJString("json"))
  if valid_589139 != nil:
    section.add "alt", valid_589139
  var valid_589140 = query.getOrDefault("oauth_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "oauth_token", valid_589140
  var valid_589141 = query.getOrDefault("userIp")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "userIp", valid_589141
  var valid_589142 = query.getOrDefault("key")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "key", valid_589142
  var valid_589143 = query.getOrDefault("prettyPrint")
  valid_589143 = validateParameter(valid_589143, JBool, required = false,
                                 default = newJBool(true))
  if valid_589143 != nil:
    section.add "prettyPrint", valid_589143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589144: Call_AdsensehostAccountsAdunitsGet_589131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified host ad unit in this AdSense account.
  ## 
  let valid = call_589144.validator(path, query, header, formData, body)
  let scheme = call_589144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589144.url(scheme.get, call_589144.host, call_589144.base,
                         call_589144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589144, url, valid)

proc call*(call_589145: Call_AdsensehostAccountsAdunitsGet_589131;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsGet
  ## Get the specified host ad unit in this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad unit.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589146 = newJObject()
  var query_589147 = newJObject()
  add(query_589147, "fields", newJString(fields))
  add(query_589147, "quotaUser", newJString(quotaUser))
  add(query_589147, "alt", newJString(alt))
  add(query_589147, "oauth_token", newJString(oauthToken))
  add(path_589146, "accountId", newJString(accountId))
  add(query_589147, "userIp", newJString(userIp))
  add(query_589147, "key", newJString(key))
  add(path_589146, "adClientId", newJString(adClientId))
  add(path_589146, "adUnitId", newJString(adUnitId))
  add(query_589147, "prettyPrint", newJBool(prettyPrint))
  result = call_589145.call(path_589146, query_589147, nil, nil, nil)

var adsensehostAccountsAdunitsGet* = Call_AdsensehostAccountsAdunitsGet_589131(
    name: "adsensehostAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsensehostAccountsAdunitsGet_589132,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsGet_589133,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsDelete_589148 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsAdunitsDelete_589150(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsDelete_589149(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified ad unit from the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad unit.
  ##   adClientId: JString (required)
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589151 = path.getOrDefault("accountId")
  valid_589151 = validateParameter(valid_589151, JString, required = true,
                                 default = nil)
  if valid_589151 != nil:
    section.add "accountId", valid_589151
  var valid_589152 = path.getOrDefault("adClientId")
  valid_589152 = validateParameter(valid_589152, JString, required = true,
                                 default = nil)
  if valid_589152 != nil:
    section.add "adClientId", valid_589152
  var valid_589153 = path.getOrDefault("adUnitId")
  valid_589153 = validateParameter(valid_589153, JString, required = true,
                                 default = nil)
  if valid_589153 != nil:
    section.add "adUnitId", valid_589153
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589154 = query.getOrDefault("fields")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "fields", valid_589154
  var valid_589155 = query.getOrDefault("quotaUser")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "quotaUser", valid_589155
  var valid_589156 = query.getOrDefault("alt")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("json"))
  if valid_589156 != nil:
    section.add "alt", valid_589156
  var valid_589157 = query.getOrDefault("oauth_token")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "oauth_token", valid_589157
  var valid_589158 = query.getOrDefault("userIp")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "userIp", valid_589158
  var valid_589159 = query.getOrDefault("key")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "key", valid_589159
  var valid_589160 = query.getOrDefault("prettyPrint")
  valid_589160 = validateParameter(valid_589160, JBool, required = false,
                                 default = newJBool(true))
  if valid_589160 != nil:
    section.add "prettyPrint", valid_589160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589161: Call_AdsensehostAccountsAdunitsDelete_589148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the specified ad unit from the specified publisher AdSense account.
  ## 
  let valid = call_589161.validator(path, query, header, formData, body)
  let scheme = call_589161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589161.url(scheme.get, call_589161.host, call_589161.base,
                         call_589161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589161, url, valid)

proc call*(call_589162: Call_AdsensehostAccountsAdunitsDelete_589148;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsDelete
  ## Delete the specified ad unit from the specified publisher AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad unit.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to delete.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589163 = newJObject()
  var query_589164 = newJObject()
  add(query_589164, "fields", newJString(fields))
  add(query_589164, "quotaUser", newJString(quotaUser))
  add(query_589164, "alt", newJString(alt))
  add(query_589164, "oauth_token", newJString(oauthToken))
  add(path_589163, "accountId", newJString(accountId))
  add(query_589164, "userIp", newJString(userIp))
  add(query_589164, "key", newJString(key))
  add(path_589163, "adClientId", newJString(adClientId))
  add(path_589163, "adUnitId", newJString(adUnitId))
  add(query_589164, "prettyPrint", newJBool(prettyPrint))
  result = call_589162.call(path_589163, query_589164, nil, nil, nil)

var adsensehostAccountsAdunitsDelete* = Call_AdsensehostAccountsAdunitsDelete_589148(
    name: "adsensehostAccountsAdunitsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsensehostAccountsAdunitsDelete_589149,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsDelete_589150,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsGetAdCode_589165 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsAdunitsGetAdCode_589167(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsGetAdCode_589166(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get ad code for the specified ad unit, attaching the specified host custom channels.
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
  var valid_589168 = path.getOrDefault("accountId")
  valid_589168 = validateParameter(valid_589168, JString, required = true,
                                 default = nil)
  if valid_589168 != nil:
    section.add "accountId", valid_589168
  var valid_589169 = path.getOrDefault("adClientId")
  valid_589169 = validateParameter(valid_589169, JString, required = true,
                                 default = nil)
  if valid_589169 != nil:
    section.add "adClientId", valid_589169
  var valid_589170 = path.getOrDefault("adUnitId")
  valid_589170 = validateParameter(valid_589170, JString, required = true,
                                 default = nil)
  if valid_589170 != nil:
    section.add "adUnitId", valid_589170
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   hostCustomChannelId: JArray
  ##                      : Host custom channel to attach to the ad code.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589171 = query.getOrDefault("fields")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "fields", valid_589171
  var valid_589172 = query.getOrDefault("quotaUser")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "quotaUser", valid_589172
  var valid_589173 = query.getOrDefault("alt")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = newJString("json"))
  if valid_589173 != nil:
    section.add "alt", valid_589173
  var valid_589174 = query.getOrDefault("hostCustomChannelId")
  valid_589174 = validateParameter(valid_589174, JArray, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "hostCustomChannelId", valid_589174
  var valid_589175 = query.getOrDefault("oauth_token")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "oauth_token", valid_589175
  var valid_589176 = query.getOrDefault("userIp")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "userIp", valid_589176
  var valid_589177 = query.getOrDefault("key")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "key", valid_589177
  var valid_589178 = query.getOrDefault("prettyPrint")
  valid_589178 = validateParameter(valid_589178, JBool, required = false,
                                 default = newJBool(true))
  if valid_589178 != nil:
    section.add "prettyPrint", valid_589178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589179: Call_AdsensehostAccountsAdunitsGetAdCode_589165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit, attaching the specified host custom channels.
  ## 
  let valid = call_589179.validator(path, query, header, formData, body)
  let scheme = call_589179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589179.url(scheme.get, call_589179.host, call_589179.base,
                         call_589179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589179, url, valid)

proc call*(call_589180: Call_AdsensehostAccountsAdunitsGetAdCode_589165;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          hostCustomChannelId: JsonNode = nil; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsGetAdCode
  ## Get ad code for the specified ad unit, attaching the specified host custom channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   hostCustomChannelId: JArray
  ##                      : Host custom channel to attach to the ad code.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589181 = newJObject()
  var query_589182 = newJObject()
  add(query_589182, "fields", newJString(fields))
  add(query_589182, "quotaUser", newJString(quotaUser))
  add(query_589182, "alt", newJString(alt))
  if hostCustomChannelId != nil:
    query_589182.add "hostCustomChannelId", hostCustomChannelId
  add(query_589182, "oauth_token", newJString(oauthToken))
  add(path_589181, "accountId", newJString(accountId))
  add(query_589182, "userIp", newJString(userIp))
  add(query_589182, "key", newJString(key))
  add(path_589181, "adClientId", newJString(adClientId))
  add(path_589181, "adUnitId", newJString(adUnitId))
  add(query_589182, "prettyPrint", newJBool(prettyPrint))
  result = call_589180.call(path_589181, query_589182, nil, nil, nil)

var adsensehostAccountsAdunitsGetAdCode* = Call_AdsensehostAccountsAdunitsGetAdCode_589165(
    name: "adsensehostAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsensehostAccountsAdunitsGetAdCode_589166,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsGetAdCode_589167,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsReportsGenerate_589183 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAccountsReportsGenerate_589185(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsReportsGenerate_589184(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Hosted account upon which to report.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589186 = path.getOrDefault("accountId")
  valid_589186 = validateParameter(valid_589186, JString, required = true,
                                 default = nil)
  if valid_589186 != nil:
    section.add "accountId", valid_589186
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
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
  var valid_589187 = query.getOrDefault("locale")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "locale", valid_589187
  var valid_589188 = query.getOrDefault("fields")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "fields", valid_589188
  var valid_589189 = query.getOrDefault("quotaUser")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "quotaUser", valid_589189
  var valid_589190 = query.getOrDefault("alt")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = newJString("json"))
  if valid_589190 != nil:
    section.add "alt", valid_589190
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_589191 = query.getOrDefault("endDate")
  valid_589191 = validateParameter(valid_589191, JString, required = true,
                                 default = nil)
  if valid_589191 != nil:
    section.add "endDate", valid_589191
  var valid_589192 = query.getOrDefault("startDate")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "startDate", valid_589192
  var valid_589193 = query.getOrDefault("sort")
  valid_589193 = validateParameter(valid_589193, JArray, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "sort", valid_589193
  var valid_589194 = query.getOrDefault("oauth_token")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "oauth_token", valid_589194
  var valid_589195 = query.getOrDefault("userIp")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "userIp", valid_589195
  var valid_589196 = query.getOrDefault("maxResults")
  valid_589196 = validateParameter(valid_589196, JInt, required = false, default = nil)
  if valid_589196 != nil:
    section.add "maxResults", valid_589196
  var valid_589197 = query.getOrDefault("key")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "key", valid_589197
  var valid_589198 = query.getOrDefault("metric")
  valid_589198 = validateParameter(valid_589198, JArray, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "metric", valid_589198
  var valid_589199 = query.getOrDefault("prettyPrint")
  valid_589199 = validateParameter(valid_589199, JBool, required = false,
                                 default = newJBool(true))
  if valid_589199 != nil:
    section.add "prettyPrint", valid_589199
  var valid_589200 = query.getOrDefault("dimension")
  valid_589200 = validateParameter(valid_589200, JArray, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "dimension", valid_589200
  var valid_589201 = query.getOrDefault("filter")
  valid_589201 = validateParameter(valid_589201, JArray, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "filter", valid_589201
  var valid_589202 = query.getOrDefault("startIndex")
  valid_589202 = validateParameter(valid_589202, JInt, required = false, default = nil)
  if valid_589202 != nil:
    section.add "startIndex", valid_589202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589203: Call_AdsensehostAccountsReportsGenerate_589183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_589203.validator(path, query, header, formData, body)
  let scheme = call_589203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589203.url(scheme.get, call_589203.host, call_589203.base,
                         call_589203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589203, url, valid)

proc call*(call_589204: Call_AdsensehostAccountsReportsGenerate_589183;
          endDate: string; startDate: string; accountId: string; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          sort: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; metric: JsonNode = nil;
          prettyPrint: bool = true; dimension: JsonNode = nil; filter: JsonNode = nil;
          startIndex: int = 0): Recallable =
  ## adsensehostAccountsReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Hosted account upon which to report.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
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
  var path_589205 = newJObject()
  var query_589206 = newJObject()
  add(query_589206, "locale", newJString(locale))
  add(query_589206, "fields", newJString(fields))
  add(query_589206, "quotaUser", newJString(quotaUser))
  add(query_589206, "alt", newJString(alt))
  add(query_589206, "endDate", newJString(endDate))
  add(query_589206, "startDate", newJString(startDate))
  if sort != nil:
    query_589206.add "sort", sort
  add(query_589206, "oauth_token", newJString(oauthToken))
  add(path_589205, "accountId", newJString(accountId))
  add(query_589206, "userIp", newJString(userIp))
  add(query_589206, "maxResults", newJInt(maxResults))
  add(query_589206, "key", newJString(key))
  if metric != nil:
    query_589206.add "metric", metric
  add(query_589206, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_589206.add "dimension", dimension
  if filter != nil:
    query_589206.add "filter", filter
  add(query_589206, "startIndex", newJInt(startIndex))
  result = call_589204.call(path_589205, query_589206, nil, nil, nil)

var adsensehostAccountsReportsGenerate* = Call_AdsensehostAccountsReportsGenerate_589183(
    name: "adsensehostAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsensehostAccountsReportsGenerate_589184,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsReportsGenerate_589185,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAdclientsList_589207 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAdclientsList_589209(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAdclientsList_589208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all host ad clients in this AdSense account.
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
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589210 = query.getOrDefault("fields")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "fields", valid_589210
  var valid_589211 = query.getOrDefault("pageToken")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "pageToken", valid_589211
  var valid_589212 = query.getOrDefault("quotaUser")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "quotaUser", valid_589212
  var valid_589213 = query.getOrDefault("alt")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = newJString("json"))
  if valid_589213 != nil:
    section.add "alt", valid_589213
  var valid_589214 = query.getOrDefault("oauth_token")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "oauth_token", valid_589214
  var valid_589215 = query.getOrDefault("userIp")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "userIp", valid_589215
  var valid_589216 = query.getOrDefault("maxResults")
  valid_589216 = validateParameter(valid_589216, JInt, required = false, default = nil)
  if valid_589216 != nil:
    section.add "maxResults", valid_589216
  var valid_589217 = query.getOrDefault("key")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "key", valid_589217
  var valid_589218 = query.getOrDefault("prettyPrint")
  valid_589218 = validateParameter(valid_589218, JBool, required = false,
                                 default = newJBool(true))
  if valid_589218 != nil:
    section.add "prettyPrint", valid_589218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589219: Call_AdsensehostAdclientsList_589207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host ad clients in this AdSense account.
  ## 
  let valid = call_589219.validator(path, query, header, formData, body)
  let scheme = call_589219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589219.url(scheme.get, call_589219.host, call_589219.base,
                         call_589219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589219, url, valid)

proc call*(call_589220: Call_AdsensehostAdclientsList_589207; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAdclientsList
  ## List all host ad clients in this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589221 = newJObject()
  add(query_589221, "fields", newJString(fields))
  add(query_589221, "pageToken", newJString(pageToken))
  add(query_589221, "quotaUser", newJString(quotaUser))
  add(query_589221, "alt", newJString(alt))
  add(query_589221, "oauth_token", newJString(oauthToken))
  add(query_589221, "userIp", newJString(userIp))
  add(query_589221, "maxResults", newJInt(maxResults))
  add(query_589221, "key", newJString(key))
  add(query_589221, "prettyPrint", newJBool(prettyPrint))
  result = call_589220.call(nil, query_589221, nil, nil, nil)

var adsensehostAdclientsList* = Call_AdsensehostAdclientsList_589207(
    name: "adsensehostAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsensehostAdclientsList_589208,
    base: "/adsensehost/v4.1", url: url_AdsensehostAdclientsList_589209,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAdclientsGet_589222 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAdclientsGet_589224(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAdclientsGet_589223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about one of the ad clients in the Host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_589225 = path.getOrDefault("adClientId")
  valid_589225 = validateParameter(valid_589225, JString, required = true,
                                 default = nil)
  if valid_589225 != nil:
    section.add "adClientId", valid_589225
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589226 = query.getOrDefault("fields")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "fields", valid_589226
  var valid_589227 = query.getOrDefault("quotaUser")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "quotaUser", valid_589227
  var valid_589228 = query.getOrDefault("alt")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("json"))
  if valid_589228 != nil:
    section.add "alt", valid_589228
  var valid_589229 = query.getOrDefault("oauth_token")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "oauth_token", valid_589229
  var valid_589230 = query.getOrDefault("userIp")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "userIp", valid_589230
  var valid_589231 = query.getOrDefault("key")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "key", valid_589231
  var valid_589232 = query.getOrDefault("prettyPrint")
  valid_589232 = validateParameter(valid_589232, JBool, required = false,
                                 default = newJBool(true))
  if valid_589232 != nil:
    section.add "prettyPrint", valid_589232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589233: Call_AdsensehostAdclientsGet_589222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about one of the ad clients in the Host AdSense account.
  ## 
  let valid = call_589233.validator(path, query, header, formData, body)
  let scheme = call_589233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589233.url(scheme.get, call_589233.host, call_589233.base,
                         call_589233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589233, url, valid)

proc call*(call_589234: Call_AdsensehostAdclientsGet_589222; adClientId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostAdclientsGet
  ## Get information about one of the ad clients in the Host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589235 = newJObject()
  var query_589236 = newJObject()
  add(query_589236, "fields", newJString(fields))
  add(query_589236, "quotaUser", newJString(quotaUser))
  add(query_589236, "alt", newJString(alt))
  add(query_589236, "oauth_token", newJString(oauthToken))
  add(query_589236, "userIp", newJString(userIp))
  add(query_589236, "key", newJString(key))
  add(path_589235, "adClientId", newJString(adClientId))
  add(query_589236, "prettyPrint", newJBool(prettyPrint))
  result = call_589234.call(path_589235, query_589236, nil, nil, nil)

var adsensehostAdclientsGet* = Call_AdsensehostAdclientsGet_589222(
    name: "adsensehostAdclientsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}",
    validator: validate_AdsensehostAdclientsGet_589223, base: "/adsensehost/v4.1",
    url: url_AdsensehostAdclientsGet_589224, schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsUpdate_589254 = ref object of OpenApiRestCall_588457
proc url_AdsensehostCustomchannelsUpdate_589256(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsUpdate_589255(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a custom channel in the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client in which the custom channel will be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_589257 = path.getOrDefault("adClientId")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "adClientId", valid_589257
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589258 = query.getOrDefault("fields")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "fields", valid_589258
  var valid_589259 = query.getOrDefault("quotaUser")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "quotaUser", valid_589259
  var valid_589260 = query.getOrDefault("alt")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("json"))
  if valid_589260 != nil:
    section.add "alt", valid_589260
  var valid_589261 = query.getOrDefault("oauth_token")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "oauth_token", valid_589261
  var valid_589262 = query.getOrDefault("userIp")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "userIp", valid_589262
  var valid_589263 = query.getOrDefault("key")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "key", valid_589263
  var valid_589264 = query.getOrDefault("prettyPrint")
  valid_589264 = validateParameter(valid_589264, JBool, required = false,
                                 default = newJBool(true))
  if valid_589264 != nil:
    section.add "prettyPrint", valid_589264
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

proc call*(call_589266: Call_AdsensehostCustomchannelsUpdate_589254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a custom channel in the host AdSense account.
  ## 
  let valid = call_589266.validator(path, query, header, formData, body)
  let scheme = call_589266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589266.url(scheme.get, call_589266.host, call_589266.base,
                         call_589266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589266, url, valid)

proc call*(call_589267: Call_AdsensehostCustomchannelsUpdate_589254;
          adClientId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsUpdate
  ## Update a custom channel in the host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client in which the custom channel will be updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589268 = newJObject()
  var query_589269 = newJObject()
  var body_589270 = newJObject()
  add(query_589269, "fields", newJString(fields))
  add(query_589269, "quotaUser", newJString(quotaUser))
  add(query_589269, "alt", newJString(alt))
  add(query_589269, "oauth_token", newJString(oauthToken))
  add(query_589269, "userIp", newJString(userIp))
  add(query_589269, "key", newJString(key))
  add(path_589268, "adClientId", newJString(adClientId))
  if body != nil:
    body_589270 = body
  add(query_589269, "prettyPrint", newJBool(prettyPrint))
  result = call_589267.call(path_589268, query_589269, nil, nil, body_589270)

var adsensehostCustomchannelsUpdate* = Call_AdsensehostCustomchannelsUpdate_589254(
    name: "adsensehostCustomchannelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsUpdate_589255,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsUpdate_589256,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsInsert_589271 = ref object of OpenApiRestCall_588457
proc url_AdsensehostCustomchannelsInsert_589273(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsInsert_589272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new custom channel to the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to which the new custom channel will be added.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_589274 = path.getOrDefault("adClientId")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "adClientId", valid_589274
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589275 = query.getOrDefault("fields")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "fields", valid_589275
  var valid_589276 = query.getOrDefault("quotaUser")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "quotaUser", valid_589276
  var valid_589277 = query.getOrDefault("alt")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = newJString("json"))
  if valid_589277 != nil:
    section.add "alt", valid_589277
  var valid_589278 = query.getOrDefault("oauth_token")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "oauth_token", valid_589278
  var valid_589279 = query.getOrDefault("userIp")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "userIp", valid_589279
  var valid_589280 = query.getOrDefault("key")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "key", valid_589280
  var valid_589281 = query.getOrDefault("prettyPrint")
  valid_589281 = validateParameter(valid_589281, JBool, required = false,
                                 default = newJBool(true))
  if valid_589281 != nil:
    section.add "prettyPrint", valid_589281
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

proc call*(call_589283: Call_AdsensehostCustomchannelsInsert_589271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a new custom channel to the host AdSense account.
  ## 
  let valid = call_589283.validator(path, query, header, formData, body)
  let scheme = call_589283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589283.url(scheme.get, call_589283.host, call_589283.base,
                         call_589283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589283, url, valid)

proc call*(call_589284: Call_AdsensehostCustomchannelsInsert_589271;
          adClientId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsInsert
  ## Add a new custom channel to the host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client to which the new custom channel will be added.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589285 = newJObject()
  var query_589286 = newJObject()
  var body_589287 = newJObject()
  add(query_589286, "fields", newJString(fields))
  add(query_589286, "quotaUser", newJString(quotaUser))
  add(query_589286, "alt", newJString(alt))
  add(query_589286, "oauth_token", newJString(oauthToken))
  add(query_589286, "userIp", newJString(userIp))
  add(query_589286, "key", newJString(key))
  add(path_589285, "adClientId", newJString(adClientId))
  if body != nil:
    body_589287 = body
  add(query_589286, "prettyPrint", newJBool(prettyPrint))
  result = call_589284.call(path_589285, query_589286, nil, nil, body_589287)

var adsensehostCustomchannelsInsert* = Call_AdsensehostCustomchannelsInsert_589271(
    name: "adsensehostCustomchannelsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsInsert_589272,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsInsert_589273,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsList_589237 = ref object of OpenApiRestCall_588457
proc url_AdsensehostCustomchannelsList_589239(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsList_589238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all host custom channels in this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_589240 = path.getOrDefault("adClientId")
  valid_589240 = validateParameter(valid_589240, JString, required = true,
                                 default = nil)
  if valid_589240 != nil:
    section.add "adClientId", valid_589240
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589241 = query.getOrDefault("fields")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "fields", valid_589241
  var valid_589242 = query.getOrDefault("pageToken")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "pageToken", valid_589242
  var valid_589243 = query.getOrDefault("quotaUser")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "quotaUser", valid_589243
  var valid_589244 = query.getOrDefault("alt")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("json"))
  if valid_589244 != nil:
    section.add "alt", valid_589244
  var valid_589245 = query.getOrDefault("oauth_token")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "oauth_token", valid_589245
  var valid_589246 = query.getOrDefault("userIp")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "userIp", valid_589246
  var valid_589247 = query.getOrDefault("maxResults")
  valid_589247 = validateParameter(valid_589247, JInt, required = false, default = nil)
  if valid_589247 != nil:
    section.add "maxResults", valid_589247
  var valid_589248 = query.getOrDefault("key")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "key", valid_589248
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
  if body != nil:
    result.add "body", body

proc call*(call_589250: Call_AdsensehostCustomchannelsList_589237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host custom channels in this AdSense account.
  ## 
  let valid = call_589250.validator(path, query, header, formData, body)
  let scheme = call_589250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589250.url(scheme.get, call_589250.host, call_589250.base,
                         call_589250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589250, url, valid)

proc call*(call_589251: Call_AdsensehostCustomchannelsList_589237;
          adClientId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsList
  ## List all host custom channels in this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589252 = newJObject()
  var query_589253 = newJObject()
  add(query_589253, "fields", newJString(fields))
  add(query_589253, "pageToken", newJString(pageToken))
  add(query_589253, "quotaUser", newJString(quotaUser))
  add(query_589253, "alt", newJString(alt))
  add(query_589253, "oauth_token", newJString(oauthToken))
  add(query_589253, "userIp", newJString(userIp))
  add(query_589253, "maxResults", newJInt(maxResults))
  add(query_589253, "key", newJString(key))
  add(path_589252, "adClientId", newJString(adClientId))
  add(query_589253, "prettyPrint", newJBool(prettyPrint))
  result = call_589251.call(path_589252, query_589253, nil, nil, nil)

var adsensehostCustomchannelsList* = Call_AdsensehostCustomchannelsList_589237(
    name: "adsensehostCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsList_589238,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsList_589239,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsPatch_589288 = ref object of OpenApiRestCall_588457
proc url_AdsensehostCustomchannelsPatch_589290(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsPatch_589289(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a custom channel in the host AdSense account. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client in which the custom channel will be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_589291 = path.getOrDefault("adClientId")
  valid_589291 = validateParameter(valid_589291, JString, required = true,
                                 default = nil)
  if valid_589291 != nil:
    section.add "adClientId", valid_589291
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customChannelId: JString (required)
  ##                  : Custom channel to get.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589292 = query.getOrDefault("fields")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "fields", valid_589292
  var valid_589293 = query.getOrDefault("quotaUser")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "quotaUser", valid_589293
  var valid_589294 = query.getOrDefault("alt")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = newJString("json"))
  if valid_589294 != nil:
    section.add "alt", valid_589294
  assert query != nil,
        "query argument is necessary due to required `customChannelId` field"
  var valid_589295 = query.getOrDefault("customChannelId")
  valid_589295 = validateParameter(valid_589295, JString, required = true,
                                 default = nil)
  if valid_589295 != nil:
    section.add "customChannelId", valid_589295
  var valid_589296 = query.getOrDefault("oauth_token")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "oauth_token", valid_589296
  var valid_589297 = query.getOrDefault("userIp")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "userIp", valid_589297
  var valid_589298 = query.getOrDefault("key")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "key", valid_589298
  var valid_589299 = query.getOrDefault("prettyPrint")
  valid_589299 = validateParameter(valid_589299, JBool, required = false,
                                 default = newJBool(true))
  if valid_589299 != nil:
    section.add "prettyPrint", valid_589299
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

proc call*(call_589301: Call_AdsensehostCustomchannelsPatch_589288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a custom channel in the host AdSense account. This method supports patch semantics.
  ## 
  let valid = call_589301.validator(path, query, header, formData, body)
  let scheme = call_589301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589301.url(scheme.get, call_589301.host, call_589301.base,
                         call_589301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589301, url, valid)

proc call*(call_589302: Call_AdsensehostCustomchannelsPatch_589288;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsPatch
  ## Update a custom channel in the host AdSense account. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customChannelId: string (required)
  ##                  : Custom channel to get.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client in which the custom channel will be updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589303 = newJObject()
  var query_589304 = newJObject()
  var body_589305 = newJObject()
  add(query_589304, "fields", newJString(fields))
  add(query_589304, "quotaUser", newJString(quotaUser))
  add(query_589304, "alt", newJString(alt))
  add(query_589304, "customChannelId", newJString(customChannelId))
  add(query_589304, "oauth_token", newJString(oauthToken))
  add(query_589304, "userIp", newJString(userIp))
  add(query_589304, "key", newJString(key))
  add(path_589303, "adClientId", newJString(adClientId))
  if body != nil:
    body_589305 = body
  add(query_589304, "prettyPrint", newJBool(prettyPrint))
  result = call_589302.call(path_589303, query_589304, nil, nil, body_589305)

var adsensehostCustomchannelsPatch* = Call_AdsensehostCustomchannelsPatch_589288(
    name: "adsensehostCustomchannelsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsPatch_589289,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsPatch_589290,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsGet_589306 = ref object of OpenApiRestCall_588457
proc url_AdsensehostCustomchannelsGet_589308(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "customChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostCustomchannelsGet_589307(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific custom channel from the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customChannelId: JString (required)
  ##                  : Custom channel to get.
  ##   adClientId: JString (required)
  ##             : Ad client from which to get the custom channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customChannelId` field"
  var valid_589309 = path.getOrDefault("customChannelId")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "customChannelId", valid_589309
  var valid_589310 = path.getOrDefault("adClientId")
  valid_589310 = validateParameter(valid_589310, JString, required = true,
                                 default = nil)
  if valid_589310 != nil:
    section.add "adClientId", valid_589310
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589311 = query.getOrDefault("fields")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "fields", valid_589311
  var valid_589312 = query.getOrDefault("quotaUser")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "quotaUser", valid_589312
  var valid_589313 = query.getOrDefault("alt")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("json"))
  if valid_589313 != nil:
    section.add "alt", valid_589313
  var valid_589314 = query.getOrDefault("oauth_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "oauth_token", valid_589314
  var valid_589315 = query.getOrDefault("userIp")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "userIp", valid_589315
  var valid_589316 = query.getOrDefault("key")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "key", valid_589316
  var valid_589317 = query.getOrDefault("prettyPrint")
  valid_589317 = validateParameter(valid_589317, JBool, required = false,
                                 default = newJBool(true))
  if valid_589317 != nil:
    section.add "prettyPrint", valid_589317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589318: Call_AdsensehostCustomchannelsGet_589306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific custom channel from the host AdSense account.
  ## 
  let valid = call_589318.validator(path, query, header, formData, body)
  let scheme = call_589318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589318.url(scheme.get, call_589318.host, call_589318.base,
                         call_589318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589318, url, valid)

proc call*(call_589319: Call_AdsensehostCustomchannelsGet_589306;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsGet
  ## Get a specific custom channel from the host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel to get.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client from which to get the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589320 = newJObject()
  var query_589321 = newJObject()
  add(query_589321, "fields", newJString(fields))
  add(query_589321, "quotaUser", newJString(quotaUser))
  add(query_589321, "alt", newJString(alt))
  add(query_589321, "oauth_token", newJString(oauthToken))
  add(path_589320, "customChannelId", newJString(customChannelId))
  add(query_589321, "userIp", newJString(userIp))
  add(query_589321, "key", newJString(key))
  add(path_589320, "adClientId", newJString(adClientId))
  add(query_589321, "prettyPrint", newJBool(prettyPrint))
  result = call_589319.call(path_589320, query_589321, nil, nil, nil)

var adsensehostCustomchannelsGet* = Call_AdsensehostCustomchannelsGet_589306(
    name: "adsensehostCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsensehostCustomchannelsGet_589307,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsGet_589308,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsDelete_589322 = ref object of OpenApiRestCall_588457
proc url_AdsensehostCustomchannelsDelete_589324(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "customChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostCustomchannelsDelete_589323(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a specific custom channel from the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customChannelId: JString (required)
  ##                  : Custom channel to delete.
  ##   adClientId: JString (required)
  ##             : Ad client from which to delete the custom channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customChannelId` field"
  var valid_589325 = path.getOrDefault("customChannelId")
  valid_589325 = validateParameter(valid_589325, JString, required = true,
                                 default = nil)
  if valid_589325 != nil:
    section.add "customChannelId", valid_589325
  var valid_589326 = path.getOrDefault("adClientId")
  valid_589326 = validateParameter(valid_589326, JString, required = true,
                                 default = nil)
  if valid_589326 != nil:
    section.add "adClientId", valid_589326
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589327 = query.getOrDefault("fields")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "fields", valid_589327
  var valid_589328 = query.getOrDefault("quotaUser")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "quotaUser", valid_589328
  var valid_589329 = query.getOrDefault("alt")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = newJString("json"))
  if valid_589329 != nil:
    section.add "alt", valid_589329
  var valid_589330 = query.getOrDefault("oauth_token")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "oauth_token", valid_589330
  var valid_589331 = query.getOrDefault("userIp")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "userIp", valid_589331
  var valid_589332 = query.getOrDefault("key")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "key", valid_589332
  var valid_589333 = query.getOrDefault("prettyPrint")
  valid_589333 = validateParameter(valid_589333, JBool, required = false,
                                 default = newJBool(true))
  if valid_589333 != nil:
    section.add "prettyPrint", valid_589333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589334: Call_AdsensehostCustomchannelsDelete_589322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a specific custom channel from the host AdSense account.
  ## 
  let valid = call_589334.validator(path, query, header, formData, body)
  let scheme = call_589334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589334.url(scheme.get, call_589334.host, call_589334.base,
                         call_589334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589334, url, valid)

proc call*(call_589335: Call_AdsensehostCustomchannelsDelete_589322;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsDelete
  ## Delete a specific custom channel from the host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel to delete.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client from which to delete the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589336 = newJObject()
  var query_589337 = newJObject()
  add(query_589337, "fields", newJString(fields))
  add(query_589337, "quotaUser", newJString(quotaUser))
  add(query_589337, "alt", newJString(alt))
  add(query_589337, "oauth_token", newJString(oauthToken))
  add(path_589336, "customChannelId", newJString(customChannelId))
  add(query_589337, "userIp", newJString(userIp))
  add(query_589337, "key", newJString(key))
  add(path_589336, "adClientId", newJString(adClientId))
  add(query_589337, "prettyPrint", newJBool(prettyPrint))
  result = call_589335.call(path_589336, query_589337, nil, nil, nil)

var adsensehostCustomchannelsDelete* = Call_AdsensehostCustomchannelsDelete_589322(
    name: "adsensehostCustomchannelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsensehostCustomchannelsDelete_589323,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsDelete_589324,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsInsert_589355 = ref object of OpenApiRestCall_588457
proc url_AdsensehostUrlchannelsInsert_589357(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsensehostUrlchannelsInsert_589356(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new URL channel to the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to which the new URL channel will be added.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_589358 = path.getOrDefault("adClientId")
  valid_589358 = validateParameter(valid_589358, JString, required = true,
                                 default = nil)
  if valid_589358 != nil:
    section.add "adClientId", valid_589358
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589359 = query.getOrDefault("fields")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "fields", valid_589359
  var valid_589360 = query.getOrDefault("quotaUser")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "quotaUser", valid_589360
  var valid_589361 = query.getOrDefault("alt")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = newJString("json"))
  if valid_589361 != nil:
    section.add "alt", valid_589361
  var valid_589362 = query.getOrDefault("oauth_token")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "oauth_token", valid_589362
  var valid_589363 = query.getOrDefault("userIp")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "userIp", valid_589363
  var valid_589364 = query.getOrDefault("key")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "key", valid_589364
  var valid_589365 = query.getOrDefault("prettyPrint")
  valid_589365 = validateParameter(valid_589365, JBool, required = false,
                                 default = newJBool(true))
  if valid_589365 != nil:
    section.add "prettyPrint", valid_589365
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

proc call*(call_589367: Call_AdsensehostUrlchannelsInsert_589355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new URL channel to the host AdSense account.
  ## 
  let valid = call_589367.validator(path, query, header, formData, body)
  let scheme = call_589367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589367.url(scheme.get, call_589367.host, call_589367.base,
                         call_589367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589367, url, valid)

proc call*(call_589368: Call_AdsensehostUrlchannelsInsert_589355;
          adClientId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adsensehostUrlchannelsInsert
  ## Add a new URL channel to the host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client to which the new URL channel will be added.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589369 = newJObject()
  var query_589370 = newJObject()
  var body_589371 = newJObject()
  add(query_589370, "fields", newJString(fields))
  add(query_589370, "quotaUser", newJString(quotaUser))
  add(query_589370, "alt", newJString(alt))
  add(query_589370, "oauth_token", newJString(oauthToken))
  add(query_589370, "userIp", newJString(userIp))
  add(query_589370, "key", newJString(key))
  add(path_589369, "adClientId", newJString(adClientId))
  if body != nil:
    body_589371 = body
  add(query_589370, "prettyPrint", newJBool(prettyPrint))
  result = call_589368.call(path_589369, query_589370, nil, nil, body_589371)

var adsensehostUrlchannelsInsert* = Call_AdsensehostUrlchannelsInsert_589355(
    name: "adsensehostUrlchannelsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsensehostUrlchannelsInsert_589356,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsInsert_589357,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsList_589338 = ref object of OpenApiRestCall_588457
proc url_AdsensehostUrlchannelsList_589340(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsensehostUrlchannelsList_589339(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all host URL channels in the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_589341 = path.getOrDefault("adClientId")
  valid_589341 = validateParameter(valid_589341, JString, required = true,
                                 default = nil)
  if valid_589341 != nil:
    section.add "adClientId", valid_589341
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589342 = query.getOrDefault("fields")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "fields", valid_589342
  var valid_589343 = query.getOrDefault("pageToken")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "pageToken", valid_589343
  var valid_589344 = query.getOrDefault("quotaUser")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "quotaUser", valid_589344
  var valid_589345 = query.getOrDefault("alt")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = newJString("json"))
  if valid_589345 != nil:
    section.add "alt", valid_589345
  var valid_589346 = query.getOrDefault("oauth_token")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "oauth_token", valid_589346
  var valid_589347 = query.getOrDefault("userIp")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "userIp", valid_589347
  var valid_589348 = query.getOrDefault("maxResults")
  valid_589348 = validateParameter(valid_589348, JInt, required = false, default = nil)
  if valid_589348 != nil:
    section.add "maxResults", valid_589348
  var valid_589349 = query.getOrDefault("key")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "key", valid_589349
  var valid_589350 = query.getOrDefault("prettyPrint")
  valid_589350 = validateParameter(valid_589350, JBool, required = false,
                                 default = newJBool(true))
  if valid_589350 != nil:
    section.add "prettyPrint", valid_589350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589351: Call_AdsensehostUrlchannelsList_589338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host URL channels in the host AdSense account.
  ## 
  let valid = call_589351.validator(path, query, header, formData, body)
  let scheme = call_589351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589351.url(scheme.get, call_589351.host, call_589351.base,
                         call_589351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589351, url, valid)

proc call*(call_589352: Call_AdsensehostUrlchannelsList_589338; adClientId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostUrlchannelsList
  ## List all host URL channels in the host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589353 = newJObject()
  var query_589354 = newJObject()
  add(query_589354, "fields", newJString(fields))
  add(query_589354, "pageToken", newJString(pageToken))
  add(query_589354, "quotaUser", newJString(quotaUser))
  add(query_589354, "alt", newJString(alt))
  add(query_589354, "oauth_token", newJString(oauthToken))
  add(query_589354, "userIp", newJString(userIp))
  add(query_589354, "maxResults", newJInt(maxResults))
  add(query_589354, "key", newJString(key))
  add(path_589353, "adClientId", newJString(adClientId))
  add(query_589354, "prettyPrint", newJBool(prettyPrint))
  result = call_589352.call(path_589353, query_589354, nil, nil, nil)

var adsensehostUrlchannelsList* = Call_AdsensehostUrlchannelsList_589338(
    name: "adsensehostUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsensehostUrlchannelsList_589339,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsList_589340,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsDelete_589372 = ref object of OpenApiRestCall_588457
proc url_AdsensehostUrlchannelsDelete_589374(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "urlChannelId" in path, "`urlChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/urlchannels/"),
               (kind: VariableSegment, value: "urlChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostUrlchannelsDelete_589373(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a URL channel from the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   urlChannelId: JString (required)
  ##               : URL channel to delete.
  ##   adClientId: JString (required)
  ##             : Ad client from which to delete the URL channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `urlChannelId` field"
  var valid_589375 = path.getOrDefault("urlChannelId")
  valid_589375 = validateParameter(valid_589375, JString, required = true,
                                 default = nil)
  if valid_589375 != nil:
    section.add "urlChannelId", valid_589375
  var valid_589376 = path.getOrDefault("adClientId")
  valid_589376 = validateParameter(valid_589376, JString, required = true,
                                 default = nil)
  if valid_589376 != nil:
    section.add "adClientId", valid_589376
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589377 = query.getOrDefault("fields")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "fields", valid_589377
  var valid_589378 = query.getOrDefault("quotaUser")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "quotaUser", valid_589378
  var valid_589379 = query.getOrDefault("alt")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = newJString("json"))
  if valid_589379 != nil:
    section.add "alt", valid_589379
  var valid_589380 = query.getOrDefault("oauth_token")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "oauth_token", valid_589380
  var valid_589381 = query.getOrDefault("userIp")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "userIp", valid_589381
  var valid_589382 = query.getOrDefault("key")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "key", valid_589382
  var valid_589383 = query.getOrDefault("prettyPrint")
  valid_589383 = validateParameter(valid_589383, JBool, required = false,
                                 default = newJBool(true))
  if valid_589383 != nil:
    section.add "prettyPrint", valid_589383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589384: Call_AdsensehostUrlchannelsDelete_589372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a URL channel from the host AdSense account.
  ## 
  let valid = call_589384.validator(path, query, header, formData, body)
  let scheme = call_589384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589384.url(scheme.get, call_589384.host, call_589384.base,
                         call_589384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589384, url, valid)

proc call*(call_589385: Call_AdsensehostUrlchannelsDelete_589372;
          urlChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostUrlchannelsDelete
  ## Delete a URL channel from the host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   urlChannelId: string (required)
  ##               : URL channel to delete.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client from which to delete the URL channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589386 = newJObject()
  var query_589387 = newJObject()
  add(query_589387, "fields", newJString(fields))
  add(query_589387, "quotaUser", newJString(quotaUser))
  add(query_589387, "alt", newJString(alt))
  add(path_589386, "urlChannelId", newJString(urlChannelId))
  add(query_589387, "oauth_token", newJString(oauthToken))
  add(query_589387, "userIp", newJString(userIp))
  add(query_589387, "key", newJString(key))
  add(path_589386, "adClientId", newJString(adClientId))
  add(query_589387, "prettyPrint", newJBool(prettyPrint))
  result = call_589385.call(path_589386, query_589387, nil, nil, nil)

var adsensehostUrlchannelsDelete* = Call_AdsensehostUrlchannelsDelete_589372(
    name: "adsensehostUrlchannelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/urlchannels/{urlChannelId}",
    validator: validate_AdsensehostUrlchannelsDelete_589373,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsDelete_589374,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAssociationsessionsStart_589388 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAssociationsessionsStart_589390(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAssociationsessionsStart_589389(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an association session for initiating an association with an AdSense user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   websiteLocale: JString
  ##                : The locale of the user's hosted website.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userLocale: JString
  ##             : The preferred locale of the user.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   websiteUrl: JString (required)
  ##             : The URL of the user's hosted website.
  ##   productCode: JArray (required)
  ##              : Products to associate with the user.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589391 = query.getOrDefault("fields")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "fields", valid_589391
  var valid_589392 = query.getOrDefault("quotaUser")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "quotaUser", valid_589392
  var valid_589393 = query.getOrDefault("websiteLocale")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "websiteLocale", valid_589393
  var valid_589394 = query.getOrDefault("alt")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = newJString("json"))
  if valid_589394 != nil:
    section.add "alt", valid_589394
  var valid_589395 = query.getOrDefault("userLocale")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "userLocale", valid_589395
  var valid_589396 = query.getOrDefault("oauth_token")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "oauth_token", valid_589396
  var valid_589397 = query.getOrDefault("userIp")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "userIp", valid_589397
  var valid_589398 = query.getOrDefault("key")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "key", valid_589398
  assert query != nil,
        "query argument is necessary due to required `websiteUrl` field"
  var valid_589399 = query.getOrDefault("websiteUrl")
  valid_589399 = validateParameter(valid_589399, JString, required = true,
                                 default = nil)
  if valid_589399 != nil:
    section.add "websiteUrl", valid_589399
  var valid_589400 = query.getOrDefault("productCode")
  valid_589400 = validateParameter(valid_589400, JArray, required = true, default = nil)
  if valid_589400 != nil:
    section.add "productCode", valid_589400
  var valid_589401 = query.getOrDefault("prettyPrint")
  valid_589401 = validateParameter(valid_589401, JBool, required = false,
                                 default = newJBool(true))
  if valid_589401 != nil:
    section.add "prettyPrint", valid_589401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589402: Call_AdsensehostAssociationsessionsStart_589388;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an association session for initiating an association with an AdSense user.
  ## 
  let valid = call_589402.validator(path, query, header, formData, body)
  let scheme = call_589402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589402.url(scheme.get, call_589402.host, call_589402.base,
                         call_589402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589402, url, valid)

proc call*(call_589403: Call_AdsensehostAssociationsessionsStart_589388;
          websiteUrl: string; productCode: JsonNode; fields: string = "";
          quotaUser: string = ""; websiteLocale: string = ""; alt: string = "json";
          userLocale: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAssociationsessionsStart
  ## Create an association session for initiating an association with an AdSense user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   websiteLocale: string
  ##                : The locale of the user's hosted website.
  ##   alt: string
  ##      : Data format for the response.
  ##   userLocale: string
  ##             : The preferred locale of the user.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   websiteUrl: string (required)
  ##             : The URL of the user's hosted website.
  ##   productCode: JArray (required)
  ##              : Products to associate with the user.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589404 = newJObject()
  add(query_589404, "fields", newJString(fields))
  add(query_589404, "quotaUser", newJString(quotaUser))
  add(query_589404, "websiteLocale", newJString(websiteLocale))
  add(query_589404, "alt", newJString(alt))
  add(query_589404, "userLocale", newJString(userLocale))
  add(query_589404, "oauth_token", newJString(oauthToken))
  add(query_589404, "userIp", newJString(userIp))
  add(query_589404, "key", newJString(key))
  add(query_589404, "websiteUrl", newJString(websiteUrl))
  if productCode != nil:
    query_589404.add "productCode", productCode
  add(query_589404, "prettyPrint", newJBool(prettyPrint))
  result = call_589403.call(nil, query_589404, nil, nil, nil)

var adsensehostAssociationsessionsStart* = Call_AdsensehostAssociationsessionsStart_589388(
    name: "adsensehostAssociationsessionsStart", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/associationsessions/start",
    validator: validate_AdsensehostAssociationsessionsStart_589389,
    base: "/adsensehost/v4.1", url: url_AdsensehostAssociationsessionsStart_589390,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAssociationsessionsVerify_589405 = ref object of OpenApiRestCall_588457
proc url_AdsensehostAssociationsessionsVerify_589407(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAssociationsessionsVerify_589406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verify an association session after the association callback returns from AdSense signup.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   token: JString (required)
  ##        : The token returned to the association callback URL.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `token` field"
  var valid_589408 = query.getOrDefault("token")
  valid_589408 = validateParameter(valid_589408, JString, required = true,
                                 default = nil)
  if valid_589408 != nil:
    section.add "token", valid_589408
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
  var valid_589413 = query.getOrDefault("userIp")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "userIp", valid_589413
  var valid_589414 = query.getOrDefault("key")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "key", valid_589414
  var valid_589415 = query.getOrDefault("prettyPrint")
  valid_589415 = validateParameter(valid_589415, JBool, required = false,
                                 default = newJBool(true))
  if valid_589415 != nil:
    section.add "prettyPrint", valid_589415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589416: Call_AdsensehostAssociationsessionsVerify_589405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verify an association session after the association callback returns from AdSense signup.
  ## 
  let valid = call_589416.validator(path, query, header, formData, body)
  let scheme = call_589416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589416.url(scheme.get, call_589416.host, call_589416.base,
                         call_589416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589416, url, valid)

proc call*(call_589417: Call_AdsensehostAssociationsessionsVerify_589405;
          token: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAssociationsessionsVerify
  ## Verify an association session after the association callback returns from AdSense signup.
  ##   token: string (required)
  ##        : The token returned to the association callback URL.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589418 = newJObject()
  add(query_589418, "token", newJString(token))
  add(query_589418, "fields", newJString(fields))
  add(query_589418, "quotaUser", newJString(quotaUser))
  add(query_589418, "alt", newJString(alt))
  add(query_589418, "oauth_token", newJString(oauthToken))
  add(query_589418, "userIp", newJString(userIp))
  add(query_589418, "key", newJString(key))
  add(query_589418, "prettyPrint", newJBool(prettyPrint))
  result = call_589417.call(nil, query_589418, nil, nil, nil)

var adsensehostAssociationsessionsVerify* = Call_AdsensehostAssociationsessionsVerify_589405(
    name: "adsensehostAssociationsessionsVerify", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/associationsessions/verify",
    validator: validate_AdsensehostAssociationsessionsVerify_589406,
    base: "/adsensehost/v4.1", url: url_AdsensehostAssociationsessionsVerify_589407,
    schemes: {Scheme.Https})
type
  Call_AdsensehostReportsGenerate_589419 = ref object of OpenApiRestCall_588457
proc url_AdsensehostReportsGenerate_589421(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostReportsGenerate_589420(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
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
  var valid_589422 = query.getOrDefault("locale")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "locale", valid_589422
  var valid_589423 = query.getOrDefault("fields")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "fields", valid_589423
  var valid_589424 = query.getOrDefault("quotaUser")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "quotaUser", valid_589424
  var valid_589425 = query.getOrDefault("alt")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = newJString("json"))
  if valid_589425 != nil:
    section.add "alt", valid_589425
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_589426 = query.getOrDefault("endDate")
  valid_589426 = validateParameter(valid_589426, JString, required = true,
                                 default = nil)
  if valid_589426 != nil:
    section.add "endDate", valid_589426
  var valid_589427 = query.getOrDefault("startDate")
  valid_589427 = validateParameter(valid_589427, JString, required = true,
                                 default = nil)
  if valid_589427 != nil:
    section.add "startDate", valid_589427
  var valid_589428 = query.getOrDefault("sort")
  valid_589428 = validateParameter(valid_589428, JArray, required = false,
                                 default = nil)
  if valid_589428 != nil:
    section.add "sort", valid_589428
  var valid_589429 = query.getOrDefault("oauth_token")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "oauth_token", valid_589429
  var valid_589430 = query.getOrDefault("userIp")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "userIp", valid_589430
  var valid_589431 = query.getOrDefault("maxResults")
  valid_589431 = validateParameter(valid_589431, JInt, required = false, default = nil)
  if valid_589431 != nil:
    section.add "maxResults", valid_589431
  var valid_589432 = query.getOrDefault("key")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "key", valid_589432
  var valid_589433 = query.getOrDefault("metric")
  valid_589433 = validateParameter(valid_589433, JArray, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "metric", valid_589433
  var valid_589434 = query.getOrDefault("prettyPrint")
  valid_589434 = validateParameter(valid_589434, JBool, required = false,
                                 default = newJBool(true))
  if valid_589434 != nil:
    section.add "prettyPrint", valid_589434
  var valid_589435 = query.getOrDefault("dimension")
  valid_589435 = validateParameter(valid_589435, JArray, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "dimension", valid_589435
  var valid_589436 = query.getOrDefault("filter")
  valid_589436 = validateParameter(valid_589436, JArray, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "filter", valid_589436
  var valid_589437 = query.getOrDefault("startIndex")
  valid_589437 = validateParameter(valid_589437, JInt, required = false, default = nil)
  if valid_589437 != nil:
    section.add "startIndex", valid_589437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589438: Call_AdsensehostReportsGenerate_589419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_589438.validator(path, query, header, formData, body)
  let scheme = call_589438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589438.url(scheme.get, call_589438.host, call_589438.base,
                         call_589438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589438, url, valid)

proc call*(call_589439: Call_AdsensehostReportsGenerate_589419; endDate: string;
          startDate: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; sort: JsonNode = nil;
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; metric: JsonNode = nil; prettyPrint: bool = true;
          dimension: JsonNode = nil; filter: JsonNode = nil; startIndex: int = 0): Recallable =
  ## adsensehostReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
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
  var query_589440 = newJObject()
  add(query_589440, "locale", newJString(locale))
  add(query_589440, "fields", newJString(fields))
  add(query_589440, "quotaUser", newJString(quotaUser))
  add(query_589440, "alt", newJString(alt))
  add(query_589440, "endDate", newJString(endDate))
  add(query_589440, "startDate", newJString(startDate))
  if sort != nil:
    query_589440.add "sort", sort
  add(query_589440, "oauth_token", newJString(oauthToken))
  add(query_589440, "userIp", newJString(userIp))
  add(query_589440, "maxResults", newJInt(maxResults))
  add(query_589440, "key", newJString(key))
  if metric != nil:
    query_589440.add "metric", metric
  add(query_589440, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_589440.add "dimension", dimension
  if filter != nil:
    query_589440.add "filter", filter
  add(query_589440, "startIndex", newJInt(startIndex))
  result = call_589439.call(nil, query_589440, nil, nil, nil)

var adsensehostReportsGenerate* = Call_AdsensehostReportsGenerate_589419(
    name: "adsensehostReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsensehostReportsGenerate_589420,
    base: "/adsensehost/v4.1", url: url_AdsensehostReportsGenerate_589421,
    schemes: {Scheme.Https})
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
