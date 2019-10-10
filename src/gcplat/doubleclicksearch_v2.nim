
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Search Ads 360
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Reports and modifies your advertising data in DoubleClick Search (for example, campaigns, ad groups, keywords, and conversions).
## 
## https://developers.google.com/doubleclick-search/
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
  gcpServiceName = "doubleclicksearch"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DoubleclicksearchConversionGet_588725 = ref object of OpenApiRestCall_588457
proc url_DoubleclicksearchConversionGet_588727(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "agencyId" in path, "`agencyId` is a required path parameter"
  assert "advertiserId" in path, "`advertiserId` is a required path parameter"
  assert "engineAccountId" in path, "`engineAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/agency/"),
               (kind: VariableSegment, value: "agencyId"),
               (kind: ConstantSegment, value: "/advertiser/"),
               (kind: VariableSegment, value: "advertiserId"),
               (kind: ConstantSegment, value: "/engine/"),
               (kind: VariableSegment, value: "engineAccountId"),
               (kind: ConstantSegment, value: "/conversion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchConversionGet_588726(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of conversions from a DoubleClick Search engine account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   agencyId: JString (required)
  ##           : Numeric ID of the agency.
  ##   engineAccountId: JString (required)
  ##                  : Numeric ID of the engine account.
  ##   advertiserId: JString (required)
  ##               : Numeric ID of the advertiser.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `agencyId` field"
  var valid_588853 = path.getOrDefault("agencyId")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "agencyId", valid_588853
  var valid_588854 = path.getOrDefault("engineAccountId")
  valid_588854 = validateParameter(valid_588854, JString, required = true,
                                 default = nil)
  if valid_588854 != nil:
    section.add "engineAccountId", valid_588854
  var valid_588855 = path.getOrDefault("advertiserId")
  valid_588855 = validateParameter(valid_588855, JString, required = true,
                                 default = nil)
  if valid_588855 != nil:
    section.add "advertiserId", valid_588855
  result.add "path", section
  ## parameters in `query` object:
  ##   adGroupId: JString
  ##            : Numeric ID of the ad group.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JInt (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   startDate: JInt (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   criterionId: JString
  ##              : Numeric ID of the criterion.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   adId: JString
  ##       : Numeric ID of the ad.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   startRow: JInt (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   campaignId: JString
  ##             : Numeric ID of the campaign.
  ##   rowCount: JInt (required)
  ##           : The number of conversions to return per call.
  section = newJObject()
  var valid_588856 = query.getOrDefault("adGroupId")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "adGroupId", valid_588856
  var valid_588857 = query.getOrDefault("fields")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "fields", valid_588857
  var valid_588858 = query.getOrDefault("quotaUser")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "quotaUser", valid_588858
  var valid_588872 = query.getOrDefault("alt")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = newJString("json"))
  if valid_588872 != nil:
    section.add "alt", valid_588872
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_588873 = query.getOrDefault("endDate")
  valid_588873 = validateParameter(valid_588873, JInt, required = true, default = nil)
  if valid_588873 != nil:
    section.add "endDate", valid_588873
  var valid_588874 = query.getOrDefault("startDate")
  valid_588874 = validateParameter(valid_588874, JInt, required = true, default = nil)
  if valid_588874 != nil:
    section.add "startDate", valid_588874
  var valid_588875 = query.getOrDefault("criterionId")
  valid_588875 = validateParameter(valid_588875, JString, required = false,
                                 default = nil)
  if valid_588875 != nil:
    section.add "criterionId", valid_588875
  var valid_588876 = query.getOrDefault("oauth_token")
  valid_588876 = validateParameter(valid_588876, JString, required = false,
                                 default = nil)
  if valid_588876 != nil:
    section.add "oauth_token", valid_588876
  var valid_588877 = query.getOrDefault("userIp")
  valid_588877 = validateParameter(valid_588877, JString, required = false,
                                 default = nil)
  if valid_588877 != nil:
    section.add "userIp", valid_588877
  var valid_588878 = query.getOrDefault("adId")
  valid_588878 = validateParameter(valid_588878, JString, required = false,
                                 default = nil)
  if valid_588878 != nil:
    section.add "adId", valid_588878
  var valid_588879 = query.getOrDefault("key")
  valid_588879 = validateParameter(valid_588879, JString, required = false,
                                 default = nil)
  if valid_588879 != nil:
    section.add "key", valid_588879
  var valid_588880 = query.getOrDefault("startRow")
  valid_588880 = validateParameter(valid_588880, JInt, required = true, default = nil)
  if valid_588880 != nil:
    section.add "startRow", valid_588880
  var valid_588881 = query.getOrDefault("prettyPrint")
  valid_588881 = validateParameter(valid_588881, JBool, required = false,
                                 default = newJBool(true))
  if valid_588881 != nil:
    section.add "prettyPrint", valid_588881
  var valid_588882 = query.getOrDefault("campaignId")
  valid_588882 = validateParameter(valid_588882, JString, required = false,
                                 default = nil)
  if valid_588882 != nil:
    section.add "campaignId", valid_588882
  var valid_588883 = query.getOrDefault("rowCount")
  valid_588883 = validateParameter(valid_588883, JInt, required = true, default = nil)
  if valid_588883 != nil:
    section.add "rowCount", valid_588883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588906: Call_DoubleclicksearchConversionGet_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of conversions from a DoubleClick Search engine account.
  ## 
  let valid = call_588906.validator(path, query, header, formData, body)
  let scheme = call_588906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588906.url(scheme.get, call_588906.host, call_588906.base,
                         call_588906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588906, url, valid)

proc call*(call_588977: Call_DoubleclicksearchConversionGet_588725; endDate: int;
          agencyId: string; engineAccountId: string; startDate: int; startRow: int;
          advertiserId: string; rowCount: int; adGroupId: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          criterionId: string = ""; oauthToken: string = ""; userIp: string = "";
          adId: string = ""; key: string = ""; prettyPrint: bool = true;
          campaignId: string = ""): Recallable =
  ## doubleclicksearchConversionGet
  ## Retrieves a list of conversions from a DoubleClick Search engine account.
  ##   adGroupId: string
  ##            : Numeric ID of the ad group.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: int (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   agencyId: string (required)
  ##           : Numeric ID of the agency.
  ##   engineAccountId: string (required)
  ##                  : Numeric ID of the engine account.
  ##   startDate: int (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   criterionId: string
  ##              : Numeric ID of the criterion.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   adId: string
  ##       : Numeric ID of the ad.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   startRow: int (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   advertiserId: string (required)
  ##               : Numeric ID of the advertiser.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   campaignId: string
  ##             : Numeric ID of the campaign.
  ##   rowCount: int (required)
  ##           : The number of conversions to return per call.
  var path_588978 = newJObject()
  var query_588980 = newJObject()
  add(query_588980, "adGroupId", newJString(adGroupId))
  add(query_588980, "fields", newJString(fields))
  add(query_588980, "quotaUser", newJString(quotaUser))
  add(query_588980, "alt", newJString(alt))
  add(query_588980, "endDate", newJInt(endDate))
  add(path_588978, "agencyId", newJString(agencyId))
  add(path_588978, "engineAccountId", newJString(engineAccountId))
  add(query_588980, "startDate", newJInt(startDate))
  add(query_588980, "criterionId", newJString(criterionId))
  add(query_588980, "oauth_token", newJString(oauthToken))
  add(query_588980, "userIp", newJString(userIp))
  add(query_588980, "adId", newJString(adId))
  add(query_588980, "key", newJString(key))
  add(query_588980, "startRow", newJInt(startRow))
  add(path_588978, "advertiserId", newJString(advertiserId))
  add(query_588980, "prettyPrint", newJBool(prettyPrint))
  add(query_588980, "campaignId", newJString(campaignId))
  add(query_588980, "rowCount", newJInt(rowCount))
  result = call_588977.call(path_588978, query_588980, nil, nil, nil)

var doubleclicksearchConversionGet* = Call_DoubleclicksearchConversionGet_588725(
    name: "doubleclicksearchConversionGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/agency/{agencyId}/advertiser/{advertiserId}/engine/{engineAccountId}/conversion",
    validator: validate_DoubleclicksearchConversionGet_588726,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionGet_588727,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchSavedColumnsList_589019 = ref object of OpenApiRestCall_588457
proc url_DoubleclicksearchSavedColumnsList_589021(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "agencyId" in path, "`agencyId` is a required path parameter"
  assert "advertiserId" in path, "`advertiserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/agency/"),
               (kind: VariableSegment, value: "agencyId"),
               (kind: ConstantSegment, value: "/advertiser/"),
               (kind: VariableSegment, value: "advertiserId"),
               (kind: ConstantSegment, value: "/savedcolumns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchSavedColumnsList_589020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the list of saved columns for a specified advertiser.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   agencyId: JString (required)
  ##           : DS ID of the agency.
  ##   advertiserId: JString (required)
  ##               : DS ID of the advertiser.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `agencyId` field"
  var valid_589022 = path.getOrDefault("agencyId")
  valid_589022 = validateParameter(valid_589022, JString, required = true,
                                 default = nil)
  if valid_589022 != nil:
    section.add "agencyId", valid_589022
  var valid_589023 = path.getOrDefault("advertiserId")
  valid_589023 = validateParameter(valid_589023, JString, required = true,
                                 default = nil)
  if valid_589023 != nil:
    section.add "advertiserId", valid_589023
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
  var valid_589024 = query.getOrDefault("fields")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "fields", valid_589024
  var valid_589025 = query.getOrDefault("quotaUser")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "quotaUser", valid_589025
  var valid_589026 = query.getOrDefault("alt")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = newJString("json"))
  if valid_589026 != nil:
    section.add "alt", valid_589026
  var valid_589027 = query.getOrDefault("oauth_token")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "oauth_token", valid_589027
  var valid_589028 = query.getOrDefault("userIp")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "userIp", valid_589028
  var valid_589029 = query.getOrDefault("key")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "key", valid_589029
  var valid_589030 = query.getOrDefault("prettyPrint")
  valid_589030 = validateParameter(valid_589030, JBool, required = false,
                                 default = newJBool(true))
  if valid_589030 != nil:
    section.add "prettyPrint", valid_589030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589031: Call_DoubleclicksearchSavedColumnsList_589019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve the list of saved columns for a specified advertiser.
  ## 
  let valid = call_589031.validator(path, query, header, formData, body)
  let scheme = call_589031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589031.url(scheme.get, call_589031.host, call_589031.base,
                         call_589031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589031, url, valid)

proc call*(call_589032: Call_DoubleclicksearchSavedColumnsList_589019;
          agencyId: string; advertiserId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchSavedColumnsList
  ## Retrieve the list of saved columns for a specified advertiser.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   agencyId: string (required)
  ##           : DS ID of the agency.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   advertiserId: string (required)
  ##               : DS ID of the advertiser.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589033 = newJObject()
  var query_589034 = newJObject()
  add(query_589034, "fields", newJString(fields))
  add(query_589034, "quotaUser", newJString(quotaUser))
  add(query_589034, "alt", newJString(alt))
  add(path_589033, "agencyId", newJString(agencyId))
  add(query_589034, "oauth_token", newJString(oauthToken))
  add(query_589034, "userIp", newJString(userIp))
  add(query_589034, "key", newJString(key))
  add(path_589033, "advertiserId", newJString(advertiserId))
  add(query_589034, "prettyPrint", newJBool(prettyPrint))
  result = call_589032.call(path_589033, query_589034, nil, nil, nil)

var doubleclicksearchSavedColumnsList* = Call_DoubleclicksearchSavedColumnsList_589019(
    name: "doubleclicksearchSavedColumnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/agency/{agencyId}/advertiser/{advertiserId}/savedcolumns",
    validator: validate_DoubleclicksearchSavedColumnsList_589020,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchSavedColumnsList_589021,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionUpdate_589035 = ref object of OpenApiRestCall_588457
proc url_DoubleclicksearchConversionUpdate_589037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionUpdate_589036(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a batch of conversions in DoubleClick Search.
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
  var valid_589038 = query.getOrDefault("fields")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "fields", valid_589038
  var valid_589039 = query.getOrDefault("quotaUser")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "quotaUser", valid_589039
  var valid_589040 = query.getOrDefault("alt")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = newJString("json"))
  if valid_589040 != nil:
    section.add "alt", valid_589040
  var valid_589041 = query.getOrDefault("oauth_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "oauth_token", valid_589041
  var valid_589042 = query.getOrDefault("userIp")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "userIp", valid_589042
  var valid_589043 = query.getOrDefault("key")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "key", valid_589043
  var valid_589044 = query.getOrDefault("prettyPrint")
  valid_589044 = validateParameter(valid_589044, JBool, required = false,
                                 default = newJBool(true))
  if valid_589044 != nil:
    section.add "prettyPrint", valid_589044
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

proc call*(call_589046: Call_DoubleclicksearchConversionUpdate_589035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a batch of conversions in DoubleClick Search.
  ## 
  let valid = call_589046.validator(path, query, header, formData, body)
  let scheme = call_589046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589046.url(scheme.get, call_589046.host, call_589046.base,
                         call_589046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589046, url, valid)

proc call*(call_589047: Call_DoubleclicksearchConversionUpdate_589035;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchConversionUpdate
  ## Updates a batch of conversions in DoubleClick Search.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589048 = newJObject()
  var body_589049 = newJObject()
  add(query_589048, "fields", newJString(fields))
  add(query_589048, "quotaUser", newJString(quotaUser))
  add(query_589048, "alt", newJString(alt))
  add(query_589048, "oauth_token", newJString(oauthToken))
  add(query_589048, "userIp", newJString(userIp))
  add(query_589048, "key", newJString(key))
  if body != nil:
    body_589049 = body
  add(query_589048, "prettyPrint", newJBool(prettyPrint))
  result = call_589047.call(nil, query_589048, nil, nil, body_589049)

var doubleclicksearchConversionUpdate* = Call_DoubleclicksearchConversionUpdate_589035(
    name: "doubleclicksearchConversionUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionUpdate_589036,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionUpdate_589037,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionInsert_589050 = ref object of OpenApiRestCall_588457
proc url_DoubleclicksearchConversionInsert_589052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionInsert_589051(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a batch of new conversions into DoubleClick Search.
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
  var valid_589057 = query.getOrDefault("userIp")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "userIp", valid_589057
  var valid_589058 = query.getOrDefault("key")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "key", valid_589058
  var valid_589059 = query.getOrDefault("prettyPrint")
  valid_589059 = validateParameter(valid_589059, JBool, required = false,
                                 default = newJBool(true))
  if valid_589059 != nil:
    section.add "prettyPrint", valid_589059
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

proc call*(call_589061: Call_DoubleclicksearchConversionInsert_589050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a batch of new conversions into DoubleClick Search.
  ## 
  let valid = call_589061.validator(path, query, header, formData, body)
  let scheme = call_589061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589061.url(scheme.get, call_589061.host, call_589061.base,
                         call_589061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589061, url, valid)

proc call*(call_589062: Call_DoubleclicksearchConversionInsert_589050;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchConversionInsert
  ## Inserts a batch of new conversions into DoubleClick Search.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589063 = newJObject()
  var body_589064 = newJObject()
  add(query_589063, "fields", newJString(fields))
  add(query_589063, "quotaUser", newJString(quotaUser))
  add(query_589063, "alt", newJString(alt))
  add(query_589063, "oauth_token", newJString(oauthToken))
  add(query_589063, "userIp", newJString(userIp))
  add(query_589063, "key", newJString(key))
  if body != nil:
    body_589064 = body
  add(query_589063, "prettyPrint", newJBool(prettyPrint))
  result = call_589062.call(nil, query_589063, nil, nil, body_589064)

var doubleclicksearchConversionInsert* = Call_DoubleclicksearchConversionInsert_589050(
    name: "doubleclicksearchConversionInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionInsert_589051,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionInsert_589052,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionPatch_589065 = ref object of OpenApiRestCall_588457
proc url_DoubleclicksearchConversionPatch_589067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionPatch_589066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a batch of conversions in DoubleClick Search. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   agencyId: JString (required)
  ##           : Numeric ID of the agency.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JInt (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   startDate: JInt (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   advertiserId: JString (required)
  ##               : Numeric ID of the advertiser.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   startRow: JInt (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   engineAccountId: JString (required)
  ##                  : Numeric ID of the engine account.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   rowCount: JInt (required)
  ##           : The number of conversions to return per call.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `agencyId` field"
  var valid_589068 = query.getOrDefault("agencyId")
  valid_589068 = validateParameter(valid_589068, JString, required = true,
                                 default = nil)
  if valid_589068 != nil:
    section.add "agencyId", valid_589068
  var valid_589069 = query.getOrDefault("fields")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "fields", valid_589069
  var valid_589070 = query.getOrDefault("quotaUser")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "quotaUser", valid_589070
  var valid_589071 = query.getOrDefault("alt")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = newJString("json"))
  if valid_589071 != nil:
    section.add "alt", valid_589071
  var valid_589072 = query.getOrDefault("endDate")
  valid_589072 = validateParameter(valid_589072, JInt, required = true, default = nil)
  if valid_589072 != nil:
    section.add "endDate", valid_589072
  var valid_589073 = query.getOrDefault("startDate")
  valid_589073 = validateParameter(valid_589073, JInt, required = true, default = nil)
  if valid_589073 != nil:
    section.add "startDate", valid_589073
  var valid_589074 = query.getOrDefault("advertiserId")
  valid_589074 = validateParameter(valid_589074, JString, required = true,
                                 default = nil)
  if valid_589074 != nil:
    section.add "advertiserId", valid_589074
  var valid_589075 = query.getOrDefault("oauth_token")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "oauth_token", valid_589075
  var valid_589076 = query.getOrDefault("userIp")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "userIp", valid_589076
  var valid_589077 = query.getOrDefault("key")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "key", valid_589077
  var valid_589078 = query.getOrDefault("startRow")
  valid_589078 = validateParameter(valid_589078, JInt, required = true, default = nil)
  if valid_589078 != nil:
    section.add "startRow", valid_589078
  var valid_589079 = query.getOrDefault("engineAccountId")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "engineAccountId", valid_589079
  var valid_589080 = query.getOrDefault("prettyPrint")
  valid_589080 = validateParameter(valid_589080, JBool, required = false,
                                 default = newJBool(true))
  if valid_589080 != nil:
    section.add "prettyPrint", valid_589080
  var valid_589081 = query.getOrDefault("rowCount")
  valid_589081 = validateParameter(valid_589081, JInt, required = true, default = nil)
  if valid_589081 != nil:
    section.add "rowCount", valid_589081
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

proc call*(call_589083: Call_DoubleclicksearchConversionPatch_589065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a batch of conversions in DoubleClick Search. This method supports patch semantics.
  ## 
  let valid = call_589083.validator(path, query, header, formData, body)
  let scheme = call_589083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589083.url(scheme.get, call_589083.host, call_589083.base,
                         call_589083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589083, url, valid)

proc call*(call_589084: Call_DoubleclicksearchConversionPatch_589065;
          agencyId: string; endDate: int; startDate: int; advertiserId: string;
          startRow: int; engineAccountId: string; rowCount: int; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## doubleclicksearchConversionPatch
  ## Updates a batch of conversions in DoubleClick Search. This method supports patch semantics.
  ##   agencyId: string (required)
  ##           : Numeric ID of the agency.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: int (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   startDate: int (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   advertiserId: string (required)
  ##               : Numeric ID of the advertiser.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   startRow: int (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   engineAccountId: string (required)
  ##                  : Numeric ID of the engine account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   rowCount: int (required)
  ##           : The number of conversions to return per call.
  var query_589085 = newJObject()
  var body_589086 = newJObject()
  add(query_589085, "agencyId", newJString(agencyId))
  add(query_589085, "fields", newJString(fields))
  add(query_589085, "quotaUser", newJString(quotaUser))
  add(query_589085, "alt", newJString(alt))
  add(query_589085, "endDate", newJInt(endDate))
  add(query_589085, "startDate", newJInt(startDate))
  add(query_589085, "advertiserId", newJString(advertiserId))
  add(query_589085, "oauth_token", newJString(oauthToken))
  add(query_589085, "userIp", newJString(userIp))
  add(query_589085, "key", newJString(key))
  add(query_589085, "startRow", newJInt(startRow))
  add(query_589085, "engineAccountId", newJString(engineAccountId))
  if body != nil:
    body_589086 = body
  add(query_589085, "prettyPrint", newJBool(prettyPrint))
  add(query_589085, "rowCount", newJInt(rowCount))
  result = call_589084.call(nil, query_589085, nil, nil, body_589086)

var doubleclicksearchConversionPatch* = Call_DoubleclicksearchConversionPatch_589065(
    name: "doubleclicksearchConversionPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionPatch_589066,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionPatch_589067,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionUpdateAvailability_589087 = ref object of OpenApiRestCall_588457
proc url_DoubleclicksearchConversionUpdateAvailability_589089(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionUpdateAvailability_589088(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the availabilities of a batch of floodlight activities in DoubleClick Search.
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
  var valid_589090 = query.getOrDefault("fields")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "fields", valid_589090
  var valid_589091 = query.getOrDefault("quotaUser")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "quotaUser", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("userIp")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "userIp", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("prettyPrint")
  valid_589096 = validateParameter(valid_589096, JBool, required = false,
                                 default = newJBool(true))
  if valid_589096 != nil:
    section.add "prettyPrint", valid_589096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   empty: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589098: Call_DoubleclicksearchConversionUpdateAvailability_589087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the availabilities of a batch of floodlight activities in DoubleClick Search.
  ## 
  let valid = call_589098.validator(path, query, header, formData, body)
  let scheme = call_589098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589098.url(scheme.get, call_589098.host, call_589098.base,
                         call_589098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589098, url, valid)

proc call*(call_589099: Call_DoubleclicksearchConversionUpdateAvailability_589087;
          empty: JsonNode = nil; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchConversionUpdateAvailability
  ## Updates the availabilities of a batch of floodlight activities in DoubleClick Search.
  ##   empty: JObject
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
  var query_589100 = newJObject()
  var body_589101 = newJObject()
  if empty != nil:
    body_589101 = empty
  add(query_589100, "fields", newJString(fields))
  add(query_589100, "quotaUser", newJString(quotaUser))
  add(query_589100, "alt", newJString(alt))
  add(query_589100, "oauth_token", newJString(oauthToken))
  add(query_589100, "userIp", newJString(userIp))
  add(query_589100, "key", newJString(key))
  add(query_589100, "prettyPrint", newJBool(prettyPrint))
  result = call_589099.call(nil, query_589100, nil, nil, body_589101)

var doubleclicksearchConversionUpdateAvailability* = Call_DoubleclicksearchConversionUpdateAvailability_589087(
    name: "doubleclicksearchConversionUpdateAvailability",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/conversion/updateAvailability",
    validator: validate_DoubleclicksearchConversionUpdateAvailability_589088,
    base: "/doubleclicksearch/v2",
    url: url_DoubleclicksearchConversionUpdateAvailability_589089,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsRequest_589102 = ref object of OpenApiRestCall_588457
proc url_DoubleclicksearchReportsRequest_589104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchReportsRequest_589103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a report request into the reporting system.
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
  var valid_589105 = query.getOrDefault("fields")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "fields", valid_589105
  var valid_589106 = query.getOrDefault("quotaUser")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "quotaUser", valid_589106
  var valid_589107 = query.getOrDefault("alt")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = newJString("json"))
  if valid_589107 != nil:
    section.add "alt", valid_589107
  var valid_589108 = query.getOrDefault("oauth_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "oauth_token", valid_589108
  var valid_589109 = query.getOrDefault("userIp")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "userIp", valid_589109
  var valid_589110 = query.getOrDefault("key")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "key", valid_589110
  var valid_589111 = query.getOrDefault("prettyPrint")
  valid_589111 = validateParameter(valid_589111, JBool, required = false,
                                 default = newJBool(true))
  if valid_589111 != nil:
    section.add "prettyPrint", valid_589111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   reportRequest: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589113: Call_DoubleclicksearchReportsRequest_589102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a report request into the reporting system.
  ## 
  let valid = call_589113.validator(path, query, header, formData, body)
  let scheme = call_589113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589113.url(scheme.get, call_589113.host, call_589113.base,
                         call_589113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589113, url, valid)

proc call*(call_589114: Call_DoubleclicksearchReportsRequest_589102;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          reportRequest: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchReportsRequest
  ## Inserts a report request into the reporting system.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   reportRequest: JObject
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589115 = newJObject()
  var body_589116 = newJObject()
  add(query_589115, "fields", newJString(fields))
  add(query_589115, "quotaUser", newJString(quotaUser))
  add(query_589115, "alt", newJString(alt))
  if reportRequest != nil:
    body_589116 = reportRequest
  add(query_589115, "oauth_token", newJString(oauthToken))
  add(query_589115, "userIp", newJString(userIp))
  add(query_589115, "key", newJString(key))
  add(query_589115, "prettyPrint", newJBool(prettyPrint))
  result = call_589114.call(nil, query_589115, nil, nil, body_589116)

var doubleclicksearchReportsRequest* = Call_DoubleclicksearchReportsRequest_589102(
    name: "doubleclicksearchReportsRequest", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_DoubleclicksearchReportsRequest_589103,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsRequest_589104,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGenerate_589117 = ref object of OpenApiRestCall_588457
proc url_DoubleclicksearchReportsGenerate_589119(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchReportsGenerate_589118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates and returns a report immediately.
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
  var valid_589120 = query.getOrDefault("fields")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "fields", valid_589120
  var valid_589121 = query.getOrDefault("quotaUser")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "quotaUser", valid_589121
  var valid_589122 = query.getOrDefault("alt")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = newJString("json"))
  if valid_589122 != nil:
    section.add "alt", valid_589122
  var valid_589123 = query.getOrDefault("oauth_token")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "oauth_token", valid_589123
  var valid_589124 = query.getOrDefault("userIp")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "userIp", valid_589124
  var valid_589125 = query.getOrDefault("key")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "key", valid_589125
  var valid_589126 = query.getOrDefault("prettyPrint")
  valid_589126 = validateParameter(valid_589126, JBool, required = false,
                                 default = newJBool(true))
  if valid_589126 != nil:
    section.add "prettyPrint", valid_589126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   reportRequest: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589128: Call_DoubleclicksearchReportsGenerate_589117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates and returns a report immediately.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_DoubleclicksearchReportsGenerate_589117;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          reportRequest: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchReportsGenerate
  ## Generates and returns a report immediately.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   reportRequest: JObject
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589130 = newJObject()
  var body_589131 = newJObject()
  add(query_589130, "fields", newJString(fields))
  add(query_589130, "quotaUser", newJString(quotaUser))
  add(query_589130, "alt", newJString(alt))
  if reportRequest != nil:
    body_589131 = reportRequest
  add(query_589130, "oauth_token", newJString(oauthToken))
  add(query_589130, "userIp", newJString(userIp))
  add(query_589130, "key", newJString(key))
  add(query_589130, "prettyPrint", newJBool(prettyPrint))
  result = call_589129.call(nil, query_589130, nil, nil, body_589131)

var doubleclicksearchReportsGenerate* = Call_DoubleclicksearchReportsGenerate_589117(
    name: "doubleclicksearchReportsGenerate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/reports/generate",
    validator: validate_DoubleclicksearchReportsGenerate_589118,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGenerate_589119,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGet_589132 = ref object of OpenApiRestCall_588457
proc url_DoubleclicksearchReportsGet_589134(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "reportId" in path, "`reportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "reportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchReportsGet_589133(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Polls for the status of a report request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportId: JString (required)
  ##           : ID of the report request being polled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `reportId` field"
  var valid_589135 = path.getOrDefault("reportId")
  valid_589135 = validateParameter(valid_589135, JString, required = true,
                                 default = nil)
  if valid_589135 != nil:
    section.add "reportId", valid_589135
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
  var valid_589140 = query.getOrDefault("userIp")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "userIp", valid_589140
  var valid_589141 = query.getOrDefault("key")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "key", valid_589141
  var valid_589142 = query.getOrDefault("prettyPrint")
  valid_589142 = validateParameter(valid_589142, JBool, required = false,
                                 default = newJBool(true))
  if valid_589142 != nil:
    section.add "prettyPrint", valid_589142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589143: Call_DoubleclicksearchReportsGet_589132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Polls for the status of a report request.
  ## 
  let valid = call_589143.validator(path, query, header, formData, body)
  let scheme = call_589143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589143.url(scheme.get, call_589143.host, call_589143.base,
                         call_589143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589143, url, valid)

proc call*(call_589144: Call_DoubleclicksearchReportsGet_589132; reportId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## doubleclicksearchReportsGet
  ## Polls for the status of a report request.
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
  ##   reportId: string (required)
  ##           : ID of the report request being polled.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589145 = newJObject()
  var query_589146 = newJObject()
  add(query_589146, "fields", newJString(fields))
  add(query_589146, "quotaUser", newJString(quotaUser))
  add(query_589146, "alt", newJString(alt))
  add(query_589146, "oauth_token", newJString(oauthToken))
  add(query_589146, "userIp", newJString(userIp))
  add(query_589146, "key", newJString(key))
  add(path_589145, "reportId", newJString(reportId))
  add(query_589146, "prettyPrint", newJBool(prettyPrint))
  result = call_589144.call(path_589145, query_589146, nil, nil, nil)

var doubleclicksearchReportsGet* = Call_DoubleclicksearchReportsGet_589132(
    name: "doubleclicksearchReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{reportId}",
    validator: validate_DoubleclicksearchReportsGet_589133,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGet_589134,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGetFile_589147 = ref object of OpenApiRestCall_588457
proc url_DoubleclicksearchReportsGetFile_589149(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "reportId" in path, "`reportId` is a required path parameter"
  assert "reportFragment" in path, "`reportFragment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "reportId"),
               (kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "reportFragment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchReportsGetFile_589148(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads a report file encoded in UTF-8.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportFragment: JInt (required)
  ##                 : The index of the report fragment to download.
  ##   reportId: JString (required)
  ##           : ID of the report.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportFragment` field"
  var valid_589150 = path.getOrDefault("reportFragment")
  valid_589150 = validateParameter(valid_589150, JInt, required = true, default = nil)
  if valid_589150 != nil:
    section.add "reportFragment", valid_589150
  var valid_589151 = path.getOrDefault("reportId")
  valid_589151 = validateParameter(valid_589151, JString, required = true,
                                 default = nil)
  if valid_589151 != nil:
    section.add "reportId", valid_589151
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
  var valid_589152 = query.getOrDefault("fields")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "fields", valid_589152
  var valid_589153 = query.getOrDefault("quotaUser")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "quotaUser", valid_589153
  var valid_589154 = query.getOrDefault("alt")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = newJString("json"))
  if valid_589154 != nil:
    section.add "alt", valid_589154
  var valid_589155 = query.getOrDefault("oauth_token")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "oauth_token", valid_589155
  var valid_589156 = query.getOrDefault("userIp")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "userIp", valid_589156
  var valid_589157 = query.getOrDefault("key")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "key", valid_589157
  var valid_589158 = query.getOrDefault("prettyPrint")
  valid_589158 = validateParameter(valid_589158, JBool, required = false,
                                 default = newJBool(true))
  if valid_589158 != nil:
    section.add "prettyPrint", valid_589158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589159: Call_DoubleclicksearchReportsGetFile_589147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Downloads a report file encoded in UTF-8.
  ## 
  let valid = call_589159.validator(path, query, header, formData, body)
  let scheme = call_589159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589159.url(scheme.get, call_589159.host, call_589159.base,
                         call_589159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589159, url, valid)

proc call*(call_589160: Call_DoubleclicksearchReportsGetFile_589147;
          reportFragment: int; reportId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchReportsGetFile
  ## Downloads a report file encoded in UTF-8.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   reportFragment: int (required)
  ##                 : The index of the report fragment to download.
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
  ##   reportId: string (required)
  ##           : ID of the report.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589161 = newJObject()
  var query_589162 = newJObject()
  add(query_589162, "fields", newJString(fields))
  add(path_589161, "reportFragment", newJInt(reportFragment))
  add(query_589162, "quotaUser", newJString(quotaUser))
  add(query_589162, "alt", newJString(alt))
  add(query_589162, "oauth_token", newJString(oauthToken))
  add(query_589162, "userIp", newJString(userIp))
  add(query_589162, "key", newJString(key))
  add(path_589161, "reportId", newJString(reportId))
  add(query_589162, "prettyPrint", newJBool(prettyPrint))
  result = call_589160.call(path_589161, query_589162, nil, nil, nil)

var doubleclicksearchReportsGetFile* = Call_DoubleclicksearchReportsGetFile_589147(
    name: "doubleclicksearchReportsGetFile", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/reports/{reportId}/files/{reportFragment}",
    validator: validate_DoubleclicksearchReportsGetFile_589148,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGetFile_589149,
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
