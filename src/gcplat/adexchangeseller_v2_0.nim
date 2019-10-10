
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Ad Exchange Seller
## version: v2.0
## termsOfService: (not provided)
## license: (not provided)
## 
## Accesses the inventory of Ad Exchange seller users and generates reports.
## 
## https://developers.google.com/ad-exchange/seller-rest/
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
  gcpServiceName = "adexchangeseller"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangesellerAccountsList_588726 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsList_588728(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerAccountsList_588727(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all accounts available to this Ad Exchange account.
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
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
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

proc call*(call_588884: Call_AdexchangesellerAccountsList_588726; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accounts available to this Ad Exchange account.
  ## 
  let valid = call_588884.validator(path, query, header, formData, body)
  let scheme = call_588884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588884.url(scheme.get, call_588884.host, call_588884.base,
                         call_588884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588884, url, valid)

proc call*(call_588955: Call_AdexchangesellerAccountsList_588726;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsList
  ## List all accounts available to this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through accounts. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
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

var adexchangesellerAccountsList* = Call_AdexchangesellerAccountsList_588726(
    name: "adexchangesellerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdexchangesellerAccountsList_588727,
    base: "/adexchangeseller/v2.0", url: url_AdexchangesellerAccountsList_588728,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsGet_588996 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsGet_588998(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdexchangesellerAccountsGet_588997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about the selected Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to get information about. Tip: 'myaccount' is a valid ID.
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
  var valid_589020 = query.getOrDefault("prettyPrint")
  valid_589020 = validateParameter(valid_589020, JBool, required = false,
                                 default = newJBool(true))
  if valid_589020 != nil:
    section.add "prettyPrint", valid_589020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589021: Call_AdexchangesellerAccountsGet_588996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange account.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_AdexchangesellerAccountsGet_588996; accountId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsGet
  ## Get information about the selected Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to get information about. Tip: 'myaccount' is a valid ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589023 = newJObject()
  var query_589024 = newJObject()
  add(query_589024, "fields", newJString(fields))
  add(query_589024, "quotaUser", newJString(quotaUser))
  add(query_589024, "alt", newJString(alt))
  add(query_589024, "oauth_token", newJString(oauthToken))
  add(path_589023, "accountId", newJString(accountId))
  add(query_589024, "userIp", newJString(userIp))
  add(query_589024, "key", newJString(key))
  add(query_589024, "prettyPrint", newJBool(prettyPrint))
  result = call_589022.call(path_589023, query_589024, nil, nil, nil)

var adexchangesellerAccountsGet* = Call_AdexchangesellerAccountsGet_588996(
    name: "adexchangesellerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdexchangesellerAccountsGet_588997,
    base: "/adexchangeseller/v2.0", url: url_AdexchangesellerAccountsGet_588998,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsAdclientsList_589025 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsAdclientsList_589027(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdexchangesellerAccountsAdclientsList_589026(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589028 = path.getOrDefault("accountId")
  valid_589028 = validateParameter(valid_589028, JString, required = true,
                                 default = nil)
  if valid_589028 != nil:
    section.add "accountId", valid_589028
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
  var valid_589029 = query.getOrDefault("fields")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "fields", valid_589029
  var valid_589030 = query.getOrDefault("pageToken")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "pageToken", valid_589030
  var valid_589031 = query.getOrDefault("quotaUser")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "quotaUser", valid_589031
  var valid_589032 = query.getOrDefault("alt")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("json"))
  if valid_589032 != nil:
    section.add "alt", valid_589032
  var valid_589033 = query.getOrDefault("oauth_token")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "oauth_token", valid_589033
  var valid_589034 = query.getOrDefault("userIp")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "userIp", valid_589034
  var valid_589035 = query.getOrDefault("maxResults")
  valid_589035 = validateParameter(valid_589035, JInt, required = false, default = nil)
  if valid_589035 != nil:
    section.add "maxResults", valid_589035
  var valid_589036 = query.getOrDefault("key")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "key", valid_589036
  var valid_589037 = query.getOrDefault("prettyPrint")
  valid_589037 = validateParameter(valid_589037, JBool, required = false,
                                 default = newJBool(true))
  if valid_589037 != nil:
    section.add "prettyPrint", valid_589037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589038: Call_AdexchangesellerAccountsAdclientsList_589025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad clients in this Ad Exchange account.
  ## 
  let valid = call_589038.validator(path, query, header, formData, body)
  let scheme = call_589038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589038.url(scheme.get, call_589038.host, call_589038.base,
                         call_589038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589038, url, valid)

proc call*(call_589039: Call_AdexchangesellerAccountsAdclientsList_589025;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsAdclientsList
  ## List all ad clients in this Ad Exchange account.
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
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589040 = newJObject()
  var query_589041 = newJObject()
  add(query_589041, "fields", newJString(fields))
  add(query_589041, "pageToken", newJString(pageToken))
  add(query_589041, "quotaUser", newJString(quotaUser))
  add(query_589041, "alt", newJString(alt))
  add(query_589041, "oauth_token", newJString(oauthToken))
  add(path_589040, "accountId", newJString(accountId))
  add(query_589041, "userIp", newJString(userIp))
  add(query_589041, "maxResults", newJInt(maxResults))
  add(query_589041, "key", newJString(key))
  add(query_589041, "prettyPrint", newJBool(prettyPrint))
  result = call_589039.call(path_589040, query_589041, nil, nil, nil)

var adexchangesellerAccountsAdclientsList* = Call_AdexchangesellerAccountsAdclientsList_589025(
    name: "adexchangesellerAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdexchangesellerAccountsAdclientsList_589026,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsAdclientsList_589027, schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsCustomchannelsList_589042 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsCustomchannelsList_589044(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdexchangesellerAccountsCustomchannelsList_589043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
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
  var valid_589045 = path.getOrDefault("accountId")
  valid_589045 = validateParameter(valid_589045, JString, required = true,
                                 default = nil)
  if valid_589045 != nil:
    section.add "accountId", valid_589045
  var valid_589046 = path.getOrDefault("adClientId")
  valid_589046 = validateParameter(valid_589046, JString, required = true,
                                 default = nil)
  if valid_589046 != nil:
    section.add "adClientId", valid_589046
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
  var valid_589047 = query.getOrDefault("fields")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "fields", valid_589047
  var valid_589048 = query.getOrDefault("pageToken")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "pageToken", valid_589048
  var valid_589049 = query.getOrDefault("quotaUser")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "quotaUser", valid_589049
  var valid_589050 = query.getOrDefault("alt")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = newJString("json"))
  if valid_589050 != nil:
    section.add "alt", valid_589050
  var valid_589051 = query.getOrDefault("oauth_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "oauth_token", valid_589051
  var valid_589052 = query.getOrDefault("userIp")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "userIp", valid_589052
  var valid_589053 = query.getOrDefault("maxResults")
  valid_589053 = validateParameter(valid_589053, JInt, required = false, default = nil)
  if valid_589053 != nil:
    section.add "maxResults", valid_589053
  var valid_589054 = query.getOrDefault("key")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "key", valid_589054
  var valid_589055 = query.getOrDefault("prettyPrint")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "prettyPrint", valid_589055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589056: Call_AdexchangesellerAccountsCustomchannelsList_589042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_589056.validator(path, query, header, formData, body)
  let scheme = call_589056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589056.url(scheme.get, call_589056.host, call_589056.base,
                         call_589056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589056, url, valid)

proc call*(call_589057: Call_AdexchangesellerAccountsCustomchannelsList_589042;
          accountId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsCustomchannelsList
  ## List all custom channels in the specified ad client for this Ad Exchange account.
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
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
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
  var path_589058 = newJObject()
  var query_589059 = newJObject()
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "pageToken", newJString(pageToken))
  add(query_589059, "quotaUser", newJString(quotaUser))
  add(query_589059, "alt", newJString(alt))
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(path_589058, "accountId", newJString(accountId))
  add(query_589059, "userIp", newJString(userIp))
  add(query_589059, "maxResults", newJInt(maxResults))
  add(query_589059, "key", newJString(key))
  add(path_589058, "adClientId", newJString(adClientId))
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  result = call_589057.call(path_589058, query_589059, nil, nil, nil)

var adexchangesellerAccountsCustomchannelsList* = Call_AdexchangesellerAccountsCustomchannelsList_589042(
    name: "adexchangesellerAccountsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/customchannels",
    validator: validate_AdexchangesellerAccountsCustomchannelsList_589043,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsCustomchannelsList_589044,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsCustomchannelsGet_589060 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsCustomchannelsGet_589062(protocol: Scheme;
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
               (kind: VariableSegment, value: "customChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsCustomchannelsGet_589061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client.
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
  var valid_589063 = path.getOrDefault("accountId")
  valid_589063 = validateParameter(valid_589063, JString, required = true,
                                 default = nil)
  if valid_589063 != nil:
    section.add "accountId", valid_589063
  var valid_589064 = path.getOrDefault("customChannelId")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "customChannelId", valid_589064
  var valid_589065 = path.getOrDefault("adClientId")
  valid_589065 = validateParameter(valid_589065, JString, required = true,
                                 default = nil)
  if valid_589065 != nil:
    section.add "adClientId", valid_589065
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
  var valid_589066 = query.getOrDefault("fields")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "fields", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("alt")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("json"))
  if valid_589068 != nil:
    section.add "alt", valid_589068
  var valid_589069 = query.getOrDefault("oauth_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "oauth_token", valid_589069
  var valid_589070 = query.getOrDefault("userIp")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "userIp", valid_589070
  var valid_589071 = query.getOrDefault("key")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "key", valid_589071
  var valid_589072 = query.getOrDefault("prettyPrint")
  valid_589072 = validateParameter(valid_589072, JBool, required = false,
                                 default = newJBool(true))
  if valid_589072 != nil:
    section.add "prettyPrint", valid_589072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589073: Call_AdexchangesellerAccountsCustomchannelsGet_589060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_589073.validator(path, query, header, formData, body)
  let scheme = call_589073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589073.url(scheme.get, call_589073.host, call_589073.base,
                         call_589073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589073, url, valid)

proc call*(call_589074: Call_AdexchangesellerAccountsCustomchannelsGet_589060;
          accountId: string; customChannelId: string; adClientId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsCustomchannelsGet
  ## Get the specified custom channel from the specified ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589075 = newJObject()
  var query_589076 = newJObject()
  add(query_589076, "fields", newJString(fields))
  add(query_589076, "quotaUser", newJString(quotaUser))
  add(query_589076, "alt", newJString(alt))
  add(query_589076, "oauth_token", newJString(oauthToken))
  add(path_589075, "accountId", newJString(accountId))
  add(path_589075, "customChannelId", newJString(customChannelId))
  add(query_589076, "userIp", newJString(userIp))
  add(query_589076, "key", newJString(key))
  add(path_589075, "adClientId", newJString(adClientId))
  add(query_589076, "prettyPrint", newJBool(prettyPrint))
  result = call_589074.call(path_589075, query_589076, nil, nil, nil)

var adexchangesellerAccountsCustomchannelsGet* = Call_AdexchangesellerAccountsCustomchannelsGet_589060(
    name: "adexchangesellerAccountsCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdexchangesellerAccountsCustomchannelsGet_589061,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsCustomchannelsGet_589062,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsUrlchannelsList_589077 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsUrlchannelsList_589079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdexchangesellerAccountsUrlchannelsList_589078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
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
  var valid_589080 = path.getOrDefault("accountId")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "accountId", valid_589080
  var valid_589081 = path.getOrDefault("adClientId")
  valid_589081 = validateParameter(valid_589081, JString, required = true,
                                 default = nil)
  if valid_589081 != nil:
    section.add "adClientId", valid_589081
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
  var valid_589082 = query.getOrDefault("fields")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "fields", valid_589082
  var valid_589083 = query.getOrDefault("pageToken")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "pageToken", valid_589083
  var valid_589084 = query.getOrDefault("quotaUser")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "quotaUser", valid_589084
  var valid_589085 = query.getOrDefault("alt")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("json"))
  if valid_589085 != nil:
    section.add "alt", valid_589085
  var valid_589086 = query.getOrDefault("oauth_token")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "oauth_token", valid_589086
  var valid_589087 = query.getOrDefault("userIp")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "userIp", valid_589087
  var valid_589088 = query.getOrDefault("maxResults")
  valid_589088 = validateParameter(valid_589088, JInt, required = false, default = nil)
  if valid_589088 != nil:
    section.add "maxResults", valid_589088
  var valid_589089 = query.getOrDefault("key")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "key", valid_589089
  var valid_589090 = query.getOrDefault("prettyPrint")
  valid_589090 = validateParameter(valid_589090, JBool, required = false,
                                 default = newJBool(true))
  if valid_589090 != nil:
    section.add "prettyPrint", valid_589090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589091: Call_AdexchangesellerAccountsUrlchannelsList_589077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_589091.validator(path, query, header, formData, body)
  let scheme = call_589091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589091.url(scheme.get, call_589091.host, call_589091.base,
                         call_589091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589091, url, valid)

proc call*(call_589092: Call_AdexchangesellerAccountsUrlchannelsList_589077;
          accountId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsUrlchannelsList
  ## List all URL channels in the specified ad client for this Ad Exchange account.
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
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
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
  var path_589093 = newJObject()
  var query_589094 = newJObject()
  add(query_589094, "fields", newJString(fields))
  add(query_589094, "pageToken", newJString(pageToken))
  add(query_589094, "quotaUser", newJString(quotaUser))
  add(query_589094, "alt", newJString(alt))
  add(query_589094, "oauth_token", newJString(oauthToken))
  add(path_589093, "accountId", newJString(accountId))
  add(query_589094, "userIp", newJString(userIp))
  add(query_589094, "maxResults", newJInt(maxResults))
  add(query_589094, "key", newJString(key))
  add(path_589093, "adClientId", newJString(adClientId))
  add(query_589094, "prettyPrint", newJBool(prettyPrint))
  result = call_589092.call(path_589093, query_589094, nil, nil, nil)

var adexchangesellerAccountsUrlchannelsList* = Call_AdexchangesellerAccountsUrlchannelsList_589077(
    name: "adexchangesellerAccountsUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/urlchannels",
    validator: validate_AdexchangesellerAccountsUrlchannelsList_589078,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsUrlchannelsList_589079,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsAlertsList_589095 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsAlertsList_589097(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerAccountsAlertsList_589096(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the alerts for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the alerts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589098 = path.getOrDefault("accountId")
  valid_589098 = validateParameter(valid_589098, JString, required = true,
                                 default = nil)
  if valid_589098 != nil:
    section.add "accountId", valid_589098
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
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
  var valid_589099 = query.getOrDefault("locale")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "locale", valid_589099
  var valid_589100 = query.getOrDefault("fields")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "fields", valid_589100
  var valid_589101 = query.getOrDefault("quotaUser")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "quotaUser", valid_589101
  var valid_589102 = query.getOrDefault("alt")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("json"))
  if valid_589102 != nil:
    section.add "alt", valid_589102
  var valid_589103 = query.getOrDefault("oauth_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "oauth_token", valid_589103
  var valid_589104 = query.getOrDefault("userIp")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "userIp", valid_589104
  var valid_589105 = query.getOrDefault("key")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "key", valid_589105
  var valid_589106 = query.getOrDefault("prettyPrint")
  valid_589106 = validateParameter(valid_589106, JBool, required = false,
                                 default = newJBool(true))
  if valid_589106 != nil:
    section.add "prettyPrint", valid_589106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589107: Call_AdexchangesellerAccountsAlertsList_589095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the alerts for this Ad Exchange account.
  ## 
  let valid = call_589107.validator(path, query, header, formData, body)
  let scheme = call_589107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589107.url(scheme.get, call_589107.host, call_589107.base,
                         call_589107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589107, url, valid)

proc call*(call_589108: Call_AdexchangesellerAccountsAlertsList_589095;
          accountId: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsAlertsList
  ## List the alerts for this Ad Exchange account.
  ##   locale: string
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account owning the alerts.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589109 = newJObject()
  var query_589110 = newJObject()
  add(query_589110, "locale", newJString(locale))
  add(query_589110, "fields", newJString(fields))
  add(query_589110, "quotaUser", newJString(quotaUser))
  add(query_589110, "alt", newJString(alt))
  add(query_589110, "oauth_token", newJString(oauthToken))
  add(path_589109, "accountId", newJString(accountId))
  add(query_589110, "userIp", newJString(userIp))
  add(query_589110, "key", newJString(key))
  add(query_589110, "prettyPrint", newJBool(prettyPrint))
  result = call_589108.call(path_589109, query_589110, nil, nil, nil)

var adexchangesellerAccountsAlertsList* = Call_AdexchangesellerAccountsAlertsList_589095(
    name: "adexchangesellerAccountsAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts",
    validator: validate_AdexchangesellerAccountsAlertsList_589096,
    base: "/adexchangeseller/v2.0", url: url_AdexchangesellerAccountsAlertsList_589097,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsMetadataDimensionsList_589111 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsMetadataDimensionsList_589113(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/metadata/dimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsMetadataDimensionsList_589112(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List the metadata for the dimensions available to this AdExchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account with visibility to the dimensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589114 = path.getOrDefault("accountId")
  valid_589114 = validateParameter(valid_589114, JString, required = true,
                                 default = nil)
  if valid_589114 != nil:
    section.add "accountId", valid_589114
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
  var valid_589115 = query.getOrDefault("fields")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "fields", valid_589115
  var valid_589116 = query.getOrDefault("quotaUser")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "quotaUser", valid_589116
  var valid_589117 = query.getOrDefault("alt")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("json"))
  if valid_589117 != nil:
    section.add "alt", valid_589117
  var valid_589118 = query.getOrDefault("oauth_token")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "oauth_token", valid_589118
  var valid_589119 = query.getOrDefault("userIp")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "userIp", valid_589119
  var valid_589120 = query.getOrDefault("key")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "key", valid_589120
  var valid_589121 = query.getOrDefault("prettyPrint")
  valid_589121 = validateParameter(valid_589121, JBool, required = false,
                                 default = newJBool(true))
  if valid_589121 != nil:
    section.add "prettyPrint", valid_589121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589122: Call_AdexchangesellerAccountsMetadataDimensionsList_589111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdExchange account.
  ## 
  let valid = call_589122.validator(path, query, header, formData, body)
  let scheme = call_589122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589122.url(scheme.get, call_589122.host, call_589122.base,
                         call_589122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589122, url, valid)

proc call*(call_589123: Call_AdexchangesellerAccountsMetadataDimensionsList_589111;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsMetadataDimensionsList
  ## List the metadata for the dimensions available to this AdExchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account with visibility to the dimensions.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589124 = newJObject()
  var query_589125 = newJObject()
  add(query_589125, "fields", newJString(fields))
  add(query_589125, "quotaUser", newJString(quotaUser))
  add(query_589125, "alt", newJString(alt))
  add(query_589125, "oauth_token", newJString(oauthToken))
  add(path_589124, "accountId", newJString(accountId))
  add(query_589125, "userIp", newJString(userIp))
  add(query_589125, "key", newJString(key))
  add(query_589125, "prettyPrint", newJBool(prettyPrint))
  result = call_589123.call(path_589124, query_589125, nil, nil, nil)

var adexchangesellerAccountsMetadataDimensionsList* = Call_AdexchangesellerAccountsMetadataDimensionsList_589111(
    name: "adexchangesellerAccountsMetadataDimensionsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/accounts/{accountId}/metadata/dimensions",
    validator: validate_AdexchangesellerAccountsMetadataDimensionsList_589112,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsMetadataDimensionsList_589113,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsMetadataMetricsList_589126 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsMetadataMetricsList_589128(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/metadata/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsMetadataMetricsList_589127(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the metrics available to this AdExchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account with visibility to the metrics.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589129 = path.getOrDefault("accountId")
  valid_589129 = validateParameter(valid_589129, JString, required = true,
                                 default = nil)
  if valid_589129 != nil:
    section.add "accountId", valid_589129
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
  var valid_589130 = query.getOrDefault("fields")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "fields", valid_589130
  var valid_589131 = query.getOrDefault("quotaUser")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "quotaUser", valid_589131
  var valid_589132 = query.getOrDefault("alt")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("json"))
  if valid_589132 != nil:
    section.add "alt", valid_589132
  var valid_589133 = query.getOrDefault("oauth_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "oauth_token", valid_589133
  var valid_589134 = query.getOrDefault("userIp")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "userIp", valid_589134
  var valid_589135 = query.getOrDefault("key")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "key", valid_589135
  var valid_589136 = query.getOrDefault("prettyPrint")
  valid_589136 = validateParameter(valid_589136, JBool, required = false,
                                 default = newJBool(true))
  if valid_589136 != nil:
    section.add "prettyPrint", valid_589136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589137: Call_AdexchangesellerAccountsMetadataMetricsList_589126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdExchange account.
  ## 
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_AdexchangesellerAccountsMetadataMetricsList_589126;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsMetadataMetricsList
  ## List the metadata for the metrics available to this AdExchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account with visibility to the metrics.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589139 = newJObject()
  var query_589140 = newJObject()
  add(query_589140, "fields", newJString(fields))
  add(query_589140, "quotaUser", newJString(quotaUser))
  add(query_589140, "alt", newJString(alt))
  add(query_589140, "oauth_token", newJString(oauthToken))
  add(path_589139, "accountId", newJString(accountId))
  add(query_589140, "userIp", newJString(userIp))
  add(query_589140, "key", newJString(key))
  add(query_589140, "prettyPrint", newJBool(prettyPrint))
  result = call_589138.call(path_589139, query_589140, nil, nil, nil)

var adexchangesellerAccountsMetadataMetricsList* = Call_AdexchangesellerAccountsMetadataMetricsList_589126(
    name: "adexchangesellerAccountsMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/metadata/metrics",
    validator: validate_AdexchangesellerAccountsMetadataMetricsList_589127,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsMetadataMetricsList_589128,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsPreferreddealsList_589141 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsPreferreddealsList_589143(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/preferreddeals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsPreferreddealsList_589142(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the preferred deals for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the deals.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589144 = path.getOrDefault("accountId")
  valid_589144 = validateParameter(valid_589144, JString, required = true,
                                 default = nil)
  if valid_589144 != nil:
    section.add "accountId", valid_589144
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
  var valid_589145 = query.getOrDefault("fields")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "fields", valid_589145
  var valid_589146 = query.getOrDefault("quotaUser")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "quotaUser", valid_589146
  var valid_589147 = query.getOrDefault("alt")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = newJString("json"))
  if valid_589147 != nil:
    section.add "alt", valid_589147
  var valid_589148 = query.getOrDefault("oauth_token")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "oauth_token", valid_589148
  var valid_589149 = query.getOrDefault("userIp")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "userIp", valid_589149
  var valid_589150 = query.getOrDefault("key")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "key", valid_589150
  var valid_589151 = query.getOrDefault("prettyPrint")
  valid_589151 = validateParameter(valid_589151, JBool, required = false,
                                 default = newJBool(true))
  if valid_589151 != nil:
    section.add "prettyPrint", valid_589151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589152: Call_AdexchangesellerAccountsPreferreddealsList_589141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the preferred deals for this Ad Exchange account.
  ## 
  let valid = call_589152.validator(path, query, header, formData, body)
  let scheme = call_589152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589152.url(scheme.get, call_589152.host, call_589152.base,
                         call_589152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589152, url, valid)

proc call*(call_589153: Call_AdexchangesellerAccountsPreferreddealsList_589141;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsPreferreddealsList
  ## List the preferred deals for this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account owning the deals.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589154 = newJObject()
  var query_589155 = newJObject()
  add(query_589155, "fields", newJString(fields))
  add(query_589155, "quotaUser", newJString(quotaUser))
  add(query_589155, "alt", newJString(alt))
  add(query_589155, "oauth_token", newJString(oauthToken))
  add(path_589154, "accountId", newJString(accountId))
  add(query_589155, "userIp", newJString(userIp))
  add(query_589155, "key", newJString(key))
  add(query_589155, "prettyPrint", newJBool(prettyPrint))
  result = call_589153.call(path_589154, query_589155, nil, nil, nil)

var adexchangesellerAccountsPreferreddealsList* = Call_AdexchangesellerAccountsPreferreddealsList_589141(
    name: "adexchangesellerAccountsPreferreddealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/preferreddeals",
    validator: validate_AdexchangesellerAccountsPreferreddealsList_589142,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsPreferreddealsList_589143,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsPreferreddealsGet_589156 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsPreferreddealsGet_589158(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "dealId" in path, "`dealId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/preferreddeals/"),
               (kind: VariableSegment, value: "dealId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsPreferreddealsGet_589157(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about the selected Ad Exchange Preferred Deal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the deal.
  ##   dealId: JString (required)
  ##         : Preferred deal to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589159 = path.getOrDefault("accountId")
  valid_589159 = validateParameter(valid_589159, JString, required = true,
                                 default = nil)
  if valid_589159 != nil:
    section.add "accountId", valid_589159
  var valid_589160 = path.getOrDefault("dealId")
  valid_589160 = validateParameter(valid_589160, JString, required = true,
                                 default = nil)
  if valid_589160 != nil:
    section.add "dealId", valid_589160
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
  var valid_589161 = query.getOrDefault("fields")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "fields", valid_589161
  var valid_589162 = query.getOrDefault("quotaUser")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "quotaUser", valid_589162
  var valid_589163 = query.getOrDefault("alt")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = newJString("json"))
  if valid_589163 != nil:
    section.add "alt", valid_589163
  var valid_589164 = query.getOrDefault("oauth_token")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "oauth_token", valid_589164
  var valid_589165 = query.getOrDefault("userIp")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "userIp", valid_589165
  var valid_589166 = query.getOrDefault("key")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "key", valid_589166
  var valid_589167 = query.getOrDefault("prettyPrint")
  valid_589167 = validateParameter(valid_589167, JBool, required = false,
                                 default = newJBool(true))
  if valid_589167 != nil:
    section.add "prettyPrint", valid_589167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589168: Call_AdexchangesellerAccountsPreferreddealsGet_589156;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange Preferred Deal.
  ## 
  let valid = call_589168.validator(path, query, header, formData, body)
  let scheme = call_589168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589168.url(scheme.get, call_589168.host, call_589168.base,
                         call_589168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589168, url, valid)

proc call*(call_589169: Call_AdexchangesellerAccountsPreferreddealsGet_589156;
          accountId: string; dealId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsPreferreddealsGet
  ## Get information about the selected Ad Exchange Preferred Deal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account owning the deal.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dealId: string (required)
  ##         : Preferred deal to get information about.
  var path_589170 = newJObject()
  var query_589171 = newJObject()
  add(query_589171, "fields", newJString(fields))
  add(query_589171, "quotaUser", newJString(quotaUser))
  add(query_589171, "alt", newJString(alt))
  add(query_589171, "oauth_token", newJString(oauthToken))
  add(path_589170, "accountId", newJString(accountId))
  add(query_589171, "userIp", newJString(userIp))
  add(query_589171, "key", newJString(key))
  add(query_589171, "prettyPrint", newJBool(prettyPrint))
  add(path_589170, "dealId", newJString(dealId))
  result = call_589169.call(path_589170, query_589171, nil, nil, nil)

var adexchangesellerAccountsPreferreddealsGet* = Call_AdexchangesellerAccountsPreferreddealsGet_589156(
    name: "adexchangesellerAccountsPreferreddealsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/preferreddeals/{dealId}",
    validator: validate_AdexchangesellerAccountsPreferreddealsGet_589157,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsPreferreddealsGet_589158,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsReportsGenerate_589172 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsReportsGenerate_589174(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdexchangesellerAccountsReportsGenerate_589173(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which owns the generated report.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589175 = path.getOrDefault("accountId")
  valid_589175 = validateParameter(valid_589175, JString, required = true,
                                 default = nil)
  if valid_589175 != nil:
    section.add "accountId", valid_589175
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
  var valid_589176 = query.getOrDefault("locale")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "locale", valid_589176
  var valid_589177 = query.getOrDefault("fields")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "fields", valid_589177
  var valid_589178 = query.getOrDefault("quotaUser")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "quotaUser", valid_589178
  var valid_589179 = query.getOrDefault("alt")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = newJString("json"))
  if valid_589179 != nil:
    section.add "alt", valid_589179
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_589180 = query.getOrDefault("endDate")
  valid_589180 = validateParameter(valid_589180, JString, required = true,
                                 default = nil)
  if valid_589180 != nil:
    section.add "endDate", valid_589180
  var valid_589181 = query.getOrDefault("startDate")
  valid_589181 = validateParameter(valid_589181, JString, required = true,
                                 default = nil)
  if valid_589181 != nil:
    section.add "startDate", valid_589181
  var valid_589182 = query.getOrDefault("sort")
  valid_589182 = validateParameter(valid_589182, JArray, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "sort", valid_589182
  var valid_589183 = query.getOrDefault("oauth_token")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "oauth_token", valid_589183
  var valid_589184 = query.getOrDefault("userIp")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "userIp", valid_589184
  var valid_589185 = query.getOrDefault("maxResults")
  valid_589185 = validateParameter(valid_589185, JInt, required = false, default = nil)
  if valid_589185 != nil:
    section.add "maxResults", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("metric")
  valid_589187 = validateParameter(valid_589187, JArray, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "metric", valid_589187
  var valid_589188 = query.getOrDefault("prettyPrint")
  valid_589188 = validateParameter(valid_589188, JBool, required = false,
                                 default = newJBool(true))
  if valid_589188 != nil:
    section.add "prettyPrint", valid_589188
  var valid_589189 = query.getOrDefault("dimension")
  valid_589189 = validateParameter(valid_589189, JArray, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "dimension", valid_589189
  var valid_589190 = query.getOrDefault("filter")
  valid_589190 = validateParameter(valid_589190, JArray, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "filter", valid_589190
  var valid_589191 = query.getOrDefault("startIndex")
  valid_589191 = validateParameter(valid_589191, JInt, required = false, default = nil)
  if valid_589191 != nil:
    section.add "startIndex", valid_589191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589192: Call_AdexchangesellerAccountsReportsGenerate_589172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_589192.validator(path, query, header, formData, body)
  let scheme = call_589192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589192.url(scheme.get, call_589192.host, call_589192.base,
                         call_589192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589192, url, valid)

proc call*(call_589193: Call_AdexchangesellerAccountsReportsGenerate_589172;
          endDate: string; startDate: string; accountId: string; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          sort: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; metric: JsonNode = nil;
          prettyPrint: bool = true; dimension: JsonNode = nil; filter: JsonNode = nil;
          startIndex: int = 0): Recallable =
  ## adexchangesellerAccountsReportsGenerate
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
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
  ##            : Account which owns the generated report.
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
  var path_589194 = newJObject()
  var query_589195 = newJObject()
  add(query_589195, "locale", newJString(locale))
  add(query_589195, "fields", newJString(fields))
  add(query_589195, "quotaUser", newJString(quotaUser))
  add(query_589195, "alt", newJString(alt))
  add(query_589195, "endDate", newJString(endDate))
  add(query_589195, "startDate", newJString(startDate))
  if sort != nil:
    query_589195.add "sort", sort
  add(query_589195, "oauth_token", newJString(oauthToken))
  add(path_589194, "accountId", newJString(accountId))
  add(query_589195, "userIp", newJString(userIp))
  add(query_589195, "maxResults", newJInt(maxResults))
  add(query_589195, "key", newJString(key))
  if metric != nil:
    query_589195.add "metric", metric
  add(query_589195, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_589195.add "dimension", dimension
  if filter != nil:
    query_589195.add "filter", filter
  add(query_589195, "startIndex", newJInt(startIndex))
  result = call_589193.call(path_589194, query_589195, nil, nil, nil)

var adexchangesellerAccountsReportsGenerate* = Call_AdexchangesellerAccountsReportsGenerate_589172(
    name: "adexchangesellerAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdexchangesellerAccountsReportsGenerate_589173,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsReportsGenerate_589174,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsReportsSavedList_589196 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsReportsSavedList_589198(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdexchangesellerAccountsReportsSavedList_589197(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the saved reports.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589199 = path.getOrDefault("accountId")
  valid_589199 = validateParameter(valid_589199, JString, required = true,
                                 default = nil)
  if valid_589199 != nil:
    section.add "accountId", valid_589199
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589200 = query.getOrDefault("fields")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "fields", valid_589200
  var valid_589201 = query.getOrDefault("pageToken")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "pageToken", valid_589201
  var valid_589202 = query.getOrDefault("quotaUser")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "quotaUser", valid_589202
  var valid_589203 = query.getOrDefault("alt")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = newJString("json"))
  if valid_589203 != nil:
    section.add "alt", valid_589203
  var valid_589204 = query.getOrDefault("oauth_token")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "oauth_token", valid_589204
  var valid_589205 = query.getOrDefault("userIp")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "userIp", valid_589205
  var valid_589206 = query.getOrDefault("maxResults")
  valid_589206 = validateParameter(valid_589206, JInt, required = false, default = nil)
  if valid_589206 != nil:
    section.add "maxResults", valid_589206
  var valid_589207 = query.getOrDefault("key")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "key", valid_589207
  var valid_589208 = query.getOrDefault("prettyPrint")
  valid_589208 = validateParameter(valid_589208, JBool, required = false,
                                 default = newJBool(true))
  if valid_589208 != nil:
    section.add "prettyPrint", valid_589208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589209: Call_AdexchangesellerAccountsReportsSavedList_589196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in this Ad Exchange account.
  ## 
  let valid = call_589209.validator(path, query, header, formData, body)
  let scheme = call_589209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589209.url(scheme.get, call_589209.host, call_589209.base,
                         call_589209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589209, url, valid)

proc call*(call_589210: Call_AdexchangesellerAccountsReportsSavedList_589196;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsReportsSavedList
  ## List all saved reports in this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account owning the saved reports.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589211 = newJObject()
  var query_589212 = newJObject()
  add(query_589212, "fields", newJString(fields))
  add(query_589212, "pageToken", newJString(pageToken))
  add(query_589212, "quotaUser", newJString(quotaUser))
  add(query_589212, "alt", newJString(alt))
  add(query_589212, "oauth_token", newJString(oauthToken))
  add(path_589211, "accountId", newJString(accountId))
  add(query_589212, "userIp", newJString(userIp))
  add(query_589212, "maxResults", newJInt(maxResults))
  add(query_589212, "key", newJString(key))
  add(query_589212, "prettyPrint", newJBool(prettyPrint))
  result = call_589210.call(path_589211, query_589212, nil, nil, nil)

var adexchangesellerAccountsReportsSavedList* = Call_AdexchangesellerAccountsReportsSavedList_589196(
    name: "adexchangesellerAccountsReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports/saved",
    validator: validate_AdexchangesellerAccountsReportsSavedList_589197,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsReportsSavedList_589198,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsReportsSavedGenerate_589213 = ref object of OpenApiRestCall_588457
proc url_AdexchangesellerAccountsReportsSavedGenerate_589215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdexchangesellerAccountsReportsSavedGenerate_589214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the saved report.
  ##   savedReportId: JString (required)
  ##                : The saved report to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589216 = path.getOrDefault("accountId")
  valid_589216 = validateParameter(valid_589216, JString, required = true,
                                 default = nil)
  if valid_589216 != nil:
    section.add "accountId", valid_589216
  var valid_589217 = path.getOrDefault("savedReportId")
  valid_589217 = validateParameter(valid_589217, JString, required = true,
                                 default = nil)
  if valid_589217 != nil:
    section.add "savedReportId", valid_589217
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_589218 = query.getOrDefault("locale")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "locale", valid_589218
  var valid_589219 = query.getOrDefault("fields")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "fields", valid_589219
  var valid_589220 = query.getOrDefault("quotaUser")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "quotaUser", valid_589220
  var valid_589221 = query.getOrDefault("alt")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = newJString("json"))
  if valid_589221 != nil:
    section.add "alt", valid_589221
  var valid_589222 = query.getOrDefault("oauth_token")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "oauth_token", valid_589222
  var valid_589223 = query.getOrDefault("userIp")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "userIp", valid_589223
  var valid_589224 = query.getOrDefault("maxResults")
  valid_589224 = validateParameter(valid_589224, JInt, required = false, default = nil)
  if valid_589224 != nil:
    section.add "maxResults", valid_589224
  var valid_589225 = query.getOrDefault("key")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "key", valid_589225
  var valid_589226 = query.getOrDefault("prettyPrint")
  valid_589226 = validateParameter(valid_589226, JBool, required = false,
                                 default = newJBool(true))
  if valid_589226 != nil:
    section.add "prettyPrint", valid_589226
  var valid_589227 = query.getOrDefault("startIndex")
  valid_589227 = validateParameter(valid_589227, JInt, required = false, default = nil)
  if valid_589227 != nil:
    section.add "startIndex", valid_589227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589228: Call_AdexchangesellerAccountsReportsSavedGenerate_589213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_589228.validator(path, query, header, formData, body)
  let scheme = call_589228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589228.url(scheme.get, call_589228.host, call_589228.base,
                         call_589228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589228, url, valid)

proc call*(call_589229: Call_AdexchangesellerAccountsReportsSavedGenerate_589213;
          accountId: string; savedReportId: string; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## adexchangesellerAccountsReportsSavedGenerate
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account owning the saved report.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var path_589230 = newJObject()
  var query_589231 = newJObject()
  add(query_589231, "locale", newJString(locale))
  add(query_589231, "fields", newJString(fields))
  add(query_589231, "quotaUser", newJString(quotaUser))
  add(query_589231, "alt", newJString(alt))
  add(query_589231, "oauth_token", newJString(oauthToken))
  add(path_589230, "accountId", newJString(accountId))
  add(query_589231, "userIp", newJString(userIp))
  add(query_589231, "maxResults", newJInt(maxResults))
  add(path_589230, "savedReportId", newJString(savedReportId))
  add(query_589231, "key", newJString(key))
  add(query_589231, "prettyPrint", newJBool(prettyPrint))
  add(query_589231, "startIndex", newJInt(startIndex))
  result = call_589229.call(path_589230, query_589231, nil, nil, nil)

var adexchangesellerAccountsReportsSavedGenerate* = Call_AdexchangesellerAccountsReportsSavedGenerate_589213(
    name: "adexchangesellerAccountsReportsSavedGenerate",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/accounts/{accountId}/reports/{savedReportId}",
    validator: validate_AdexchangesellerAccountsReportsSavedGenerate_589214,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsReportsSavedGenerate_589215,
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
