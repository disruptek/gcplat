
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
  gcpServiceName = "doubleclicksearch"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DoubleclicksearchConversionGet_579692 = ref object of OpenApiRestCall_579424
proc url_DoubleclicksearchConversionGet_579694(protocol: Scheme; host: string;
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

proc validate_DoubleclicksearchConversionGet_579693(path: JsonNode;
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
  var valid_579820 = path.getOrDefault("agencyId")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "agencyId", valid_579820
  var valid_579821 = path.getOrDefault("engineAccountId")
  valid_579821 = validateParameter(valid_579821, JString, required = true,
                                 default = nil)
  if valid_579821 != nil:
    section.add "engineAccountId", valid_579821
  var valid_579822 = path.getOrDefault("advertiserId")
  valid_579822 = validateParameter(valid_579822, JString, required = true,
                                 default = nil)
  if valid_579822 != nil:
    section.add "advertiserId", valid_579822
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
  var valid_579823 = query.getOrDefault("adGroupId")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "adGroupId", valid_579823
  var valid_579824 = query.getOrDefault("fields")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "fields", valid_579824
  var valid_579825 = query.getOrDefault("quotaUser")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "quotaUser", valid_579825
  var valid_579839 = query.getOrDefault("alt")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = newJString("json"))
  if valid_579839 != nil:
    section.add "alt", valid_579839
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_579840 = query.getOrDefault("endDate")
  valid_579840 = validateParameter(valid_579840, JInt, required = true, default = nil)
  if valid_579840 != nil:
    section.add "endDate", valid_579840
  var valid_579841 = query.getOrDefault("startDate")
  valid_579841 = validateParameter(valid_579841, JInt, required = true, default = nil)
  if valid_579841 != nil:
    section.add "startDate", valid_579841
  var valid_579842 = query.getOrDefault("criterionId")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "criterionId", valid_579842
  var valid_579843 = query.getOrDefault("oauth_token")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "oauth_token", valid_579843
  var valid_579844 = query.getOrDefault("userIp")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "userIp", valid_579844
  var valid_579845 = query.getOrDefault("adId")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = nil)
  if valid_579845 != nil:
    section.add "adId", valid_579845
  var valid_579846 = query.getOrDefault("key")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "key", valid_579846
  var valid_579847 = query.getOrDefault("startRow")
  valid_579847 = validateParameter(valid_579847, JInt, required = true, default = nil)
  if valid_579847 != nil:
    section.add "startRow", valid_579847
  var valid_579848 = query.getOrDefault("prettyPrint")
  valid_579848 = validateParameter(valid_579848, JBool, required = false,
                                 default = newJBool(true))
  if valid_579848 != nil:
    section.add "prettyPrint", valid_579848
  var valid_579849 = query.getOrDefault("campaignId")
  valid_579849 = validateParameter(valid_579849, JString, required = false,
                                 default = nil)
  if valid_579849 != nil:
    section.add "campaignId", valid_579849
  var valid_579850 = query.getOrDefault("rowCount")
  valid_579850 = validateParameter(valid_579850, JInt, required = true, default = nil)
  if valid_579850 != nil:
    section.add "rowCount", valid_579850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579873: Call_DoubleclicksearchConversionGet_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of conversions from a DoubleClick Search engine account.
  ## 
  let valid = call_579873.validator(path, query, header, formData, body)
  let scheme = call_579873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579873.url(scheme.get, call_579873.host, call_579873.base,
                         call_579873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579873, url, valid)

proc call*(call_579944: Call_DoubleclicksearchConversionGet_579692; endDate: int;
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
  var path_579945 = newJObject()
  var query_579947 = newJObject()
  add(query_579947, "adGroupId", newJString(adGroupId))
  add(query_579947, "fields", newJString(fields))
  add(query_579947, "quotaUser", newJString(quotaUser))
  add(query_579947, "alt", newJString(alt))
  add(query_579947, "endDate", newJInt(endDate))
  add(path_579945, "agencyId", newJString(agencyId))
  add(path_579945, "engineAccountId", newJString(engineAccountId))
  add(query_579947, "startDate", newJInt(startDate))
  add(query_579947, "criterionId", newJString(criterionId))
  add(query_579947, "oauth_token", newJString(oauthToken))
  add(query_579947, "userIp", newJString(userIp))
  add(query_579947, "adId", newJString(adId))
  add(query_579947, "key", newJString(key))
  add(query_579947, "startRow", newJInt(startRow))
  add(path_579945, "advertiserId", newJString(advertiserId))
  add(query_579947, "prettyPrint", newJBool(prettyPrint))
  add(query_579947, "campaignId", newJString(campaignId))
  add(query_579947, "rowCount", newJInt(rowCount))
  result = call_579944.call(path_579945, query_579947, nil, nil, nil)

var doubleclicksearchConversionGet* = Call_DoubleclicksearchConversionGet_579692(
    name: "doubleclicksearchConversionGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/agency/{agencyId}/advertiser/{advertiserId}/engine/{engineAccountId}/conversion",
    validator: validate_DoubleclicksearchConversionGet_579693,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionGet_579694,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchSavedColumnsList_579986 = ref object of OpenApiRestCall_579424
proc url_DoubleclicksearchSavedColumnsList_579988(protocol: Scheme; host: string;
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

proc validate_DoubleclicksearchSavedColumnsList_579987(path: JsonNode;
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
  var valid_579989 = path.getOrDefault("agencyId")
  valid_579989 = validateParameter(valid_579989, JString, required = true,
                                 default = nil)
  if valid_579989 != nil:
    section.add "agencyId", valid_579989
  var valid_579990 = path.getOrDefault("advertiserId")
  valid_579990 = validateParameter(valid_579990, JString, required = true,
                                 default = nil)
  if valid_579990 != nil:
    section.add "advertiserId", valid_579990
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
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("alt")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("json"))
  if valid_579993 != nil:
    section.add "alt", valid_579993
  var valid_579994 = query.getOrDefault("oauth_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "oauth_token", valid_579994
  var valid_579995 = query.getOrDefault("userIp")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "userIp", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("prettyPrint")
  valid_579997 = validateParameter(valid_579997, JBool, required = false,
                                 default = newJBool(true))
  if valid_579997 != nil:
    section.add "prettyPrint", valid_579997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579998: Call_DoubleclicksearchSavedColumnsList_579986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve the list of saved columns for a specified advertiser.
  ## 
  let valid = call_579998.validator(path, query, header, formData, body)
  let scheme = call_579998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579998.url(scheme.get, call_579998.host, call_579998.base,
                         call_579998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579998, url, valid)

proc call*(call_579999: Call_DoubleclicksearchSavedColumnsList_579986;
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
  var path_580000 = newJObject()
  var query_580001 = newJObject()
  add(query_580001, "fields", newJString(fields))
  add(query_580001, "quotaUser", newJString(quotaUser))
  add(query_580001, "alt", newJString(alt))
  add(path_580000, "agencyId", newJString(agencyId))
  add(query_580001, "oauth_token", newJString(oauthToken))
  add(query_580001, "userIp", newJString(userIp))
  add(query_580001, "key", newJString(key))
  add(path_580000, "advertiserId", newJString(advertiserId))
  add(query_580001, "prettyPrint", newJBool(prettyPrint))
  result = call_579999.call(path_580000, query_580001, nil, nil, nil)

var doubleclicksearchSavedColumnsList* = Call_DoubleclicksearchSavedColumnsList_579986(
    name: "doubleclicksearchSavedColumnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/agency/{agencyId}/advertiser/{advertiserId}/savedcolumns",
    validator: validate_DoubleclicksearchSavedColumnsList_579987,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchSavedColumnsList_579988,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionUpdate_580002 = ref object of OpenApiRestCall_579424
proc url_DoubleclicksearchConversionUpdate_580004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionUpdate_580003(path: JsonNode;
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
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
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
  var valid_580009 = query.getOrDefault("userIp")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "userIp", valid_580009
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
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

proc call*(call_580013: Call_DoubleclicksearchConversionUpdate_580002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a batch of conversions in DoubleClick Search.
  ## 
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_DoubleclicksearchConversionUpdate_580002;
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
  var query_580015 = newJObject()
  var body_580016 = newJObject()
  add(query_580015, "fields", newJString(fields))
  add(query_580015, "quotaUser", newJString(quotaUser))
  add(query_580015, "alt", newJString(alt))
  add(query_580015, "oauth_token", newJString(oauthToken))
  add(query_580015, "userIp", newJString(userIp))
  add(query_580015, "key", newJString(key))
  if body != nil:
    body_580016 = body
  add(query_580015, "prettyPrint", newJBool(prettyPrint))
  result = call_580014.call(nil, query_580015, nil, nil, body_580016)

var doubleclicksearchConversionUpdate* = Call_DoubleclicksearchConversionUpdate_580002(
    name: "doubleclicksearchConversionUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionUpdate_580003,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionUpdate_580004,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionInsert_580017 = ref object of OpenApiRestCall_579424
proc url_DoubleclicksearchConversionInsert_580019(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionInsert_580018(path: JsonNode;
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
  var valid_580020 = query.getOrDefault("fields")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "fields", valid_580020
  var valid_580021 = query.getOrDefault("quotaUser")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "quotaUser", valid_580021
  var valid_580022 = query.getOrDefault("alt")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("json"))
  if valid_580022 != nil:
    section.add "alt", valid_580022
  var valid_580023 = query.getOrDefault("oauth_token")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "oauth_token", valid_580023
  var valid_580024 = query.getOrDefault("userIp")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "userIp", valid_580024
  var valid_580025 = query.getOrDefault("key")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "key", valid_580025
  var valid_580026 = query.getOrDefault("prettyPrint")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(true))
  if valid_580026 != nil:
    section.add "prettyPrint", valid_580026
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

proc call*(call_580028: Call_DoubleclicksearchConversionInsert_580017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a batch of new conversions into DoubleClick Search.
  ## 
  let valid = call_580028.validator(path, query, header, formData, body)
  let scheme = call_580028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580028.url(scheme.get, call_580028.host, call_580028.base,
                         call_580028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580028, url, valid)

proc call*(call_580029: Call_DoubleclicksearchConversionInsert_580017;
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
  var query_580030 = newJObject()
  var body_580031 = newJObject()
  add(query_580030, "fields", newJString(fields))
  add(query_580030, "quotaUser", newJString(quotaUser))
  add(query_580030, "alt", newJString(alt))
  add(query_580030, "oauth_token", newJString(oauthToken))
  add(query_580030, "userIp", newJString(userIp))
  add(query_580030, "key", newJString(key))
  if body != nil:
    body_580031 = body
  add(query_580030, "prettyPrint", newJBool(prettyPrint))
  result = call_580029.call(nil, query_580030, nil, nil, body_580031)

var doubleclicksearchConversionInsert* = Call_DoubleclicksearchConversionInsert_580017(
    name: "doubleclicksearchConversionInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionInsert_580018,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionInsert_580019,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionPatch_580032 = ref object of OpenApiRestCall_579424
proc url_DoubleclicksearchConversionPatch_580034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionPatch_580033(path: JsonNode;
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
  var valid_580035 = query.getOrDefault("agencyId")
  valid_580035 = validateParameter(valid_580035, JString, required = true,
                                 default = nil)
  if valid_580035 != nil:
    section.add "agencyId", valid_580035
  var valid_580036 = query.getOrDefault("fields")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "fields", valid_580036
  var valid_580037 = query.getOrDefault("quotaUser")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "quotaUser", valid_580037
  var valid_580038 = query.getOrDefault("alt")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("json"))
  if valid_580038 != nil:
    section.add "alt", valid_580038
  var valid_580039 = query.getOrDefault("endDate")
  valid_580039 = validateParameter(valid_580039, JInt, required = true, default = nil)
  if valid_580039 != nil:
    section.add "endDate", valid_580039
  var valid_580040 = query.getOrDefault("startDate")
  valid_580040 = validateParameter(valid_580040, JInt, required = true, default = nil)
  if valid_580040 != nil:
    section.add "startDate", valid_580040
  var valid_580041 = query.getOrDefault("advertiserId")
  valid_580041 = validateParameter(valid_580041, JString, required = true,
                                 default = nil)
  if valid_580041 != nil:
    section.add "advertiserId", valid_580041
  var valid_580042 = query.getOrDefault("oauth_token")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "oauth_token", valid_580042
  var valid_580043 = query.getOrDefault("userIp")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "userIp", valid_580043
  var valid_580044 = query.getOrDefault("key")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "key", valid_580044
  var valid_580045 = query.getOrDefault("startRow")
  valid_580045 = validateParameter(valid_580045, JInt, required = true, default = nil)
  if valid_580045 != nil:
    section.add "startRow", valid_580045
  var valid_580046 = query.getOrDefault("engineAccountId")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "engineAccountId", valid_580046
  var valid_580047 = query.getOrDefault("prettyPrint")
  valid_580047 = validateParameter(valid_580047, JBool, required = false,
                                 default = newJBool(true))
  if valid_580047 != nil:
    section.add "prettyPrint", valid_580047
  var valid_580048 = query.getOrDefault("rowCount")
  valid_580048 = validateParameter(valid_580048, JInt, required = true, default = nil)
  if valid_580048 != nil:
    section.add "rowCount", valid_580048
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

proc call*(call_580050: Call_DoubleclicksearchConversionPatch_580032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a batch of conversions in DoubleClick Search. This method supports patch semantics.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_DoubleclicksearchConversionPatch_580032;
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
  var query_580052 = newJObject()
  var body_580053 = newJObject()
  add(query_580052, "agencyId", newJString(agencyId))
  add(query_580052, "fields", newJString(fields))
  add(query_580052, "quotaUser", newJString(quotaUser))
  add(query_580052, "alt", newJString(alt))
  add(query_580052, "endDate", newJInt(endDate))
  add(query_580052, "startDate", newJInt(startDate))
  add(query_580052, "advertiserId", newJString(advertiserId))
  add(query_580052, "oauth_token", newJString(oauthToken))
  add(query_580052, "userIp", newJString(userIp))
  add(query_580052, "key", newJString(key))
  add(query_580052, "startRow", newJInt(startRow))
  add(query_580052, "engineAccountId", newJString(engineAccountId))
  if body != nil:
    body_580053 = body
  add(query_580052, "prettyPrint", newJBool(prettyPrint))
  add(query_580052, "rowCount", newJInt(rowCount))
  result = call_580051.call(nil, query_580052, nil, nil, body_580053)

var doubleclicksearchConversionPatch* = Call_DoubleclicksearchConversionPatch_580032(
    name: "doubleclicksearchConversionPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionPatch_580033,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionPatch_580034,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionUpdateAvailability_580054 = ref object of OpenApiRestCall_579424
proc url_DoubleclicksearchConversionUpdateAvailability_580056(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionUpdateAvailability_580055(
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
  var valid_580057 = query.getOrDefault("fields")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "fields", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("json"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("userIp")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "userIp", valid_580061
  var valid_580062 = query.getOrDefault("key")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "key", valid_580062
  var valid_580063 = query.getOrDefault("prettyPrint")
  valid_580063 = validateParameter(valid_580063, JBool, required = false,
                                 default = newJBool(true))
  if valid_580063 != nil:
    section.add "prettyPrint", valid_580063
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

proc call*(call_580065: Call_DoubleclicksearchConversionUpdateAvailability_580054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the availabilities of a batch of floodlight activities in DoubleClick Search.
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_DoubleclicksearchConversionUpdateAvailability_580054;
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
  var query_580067 = newJObject()
  var body_580068 = newJObject()
  if empty != nil:
    body_580068 = empty
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(query_580067, "userIp", newJString(userIp))
  add(query_580067, "key", newJString(key))
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  result = call_580066.call(nil, query_580067, nil, nil, body_580068)

var doubleclicksearchConversionUpdateAvailability* = Call_DoubleclicksearchConversionUpdateAvailability_580054(
    name: "doubleclicksearchConversionUpdateAvailability",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/conversion/updateAvailability",
    validator: validate_DoubleclicksearchConversionUpdateAvailability_580055,
    base: "/doubleclicksearch/v2",
    url: url_DoubleclicksearchConversionUpdateAvailability_580056,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsRequest_580069 = ref object of OpenApiRestCall_579424
proc url_DoubleclicksearchReportsRequest_580071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchReportsRequest_580070(path: JsonNode;
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
  var valid_580072 = query.getOrDefault("fields")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "fields", valid_580072
  var valid_580073 = query.getOrDefault("quotaUser")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "quotaUser", valid_580073
  var valid_580074 = query.getOrDefault("alt")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("json"))
  if valid_580074 != nil:
    section.add "alt", valid_580074
  var valid_580075 = query.getOrDefault("oauth_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "oauth_token", valid_580075
  var valid_580076 = query.getOrDefault("userIp")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "userIp", valid_580076
  var valid_580077 = query.getOrDefault("key")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "key", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
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

proc call*(call_580080: Call_DoubleclicksearchReportsRequest_580069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a report request into the reporting system.
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_DoubleclicksearchReportsRequest_580069;
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
  var query_580082 = newJObject()
  var body_580083 = newJObject()
  add(query_580082, "fields", newJString(fields))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(query_580082, "alt", newJString(alt))
  if reportRequest != nil:
    body_580083 = reportRequest
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(query_580082, "userIp", newJString(userIp))
  add(query_580082, "key", newJString(key))
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  result = call_580081.call(nil, query_580082, nil, nil, body_580083)

var doubleclicksearchReportsRequest* = Call_DoubleclicksearchReportsRequest_580069(
    name: "doubleclicksearchReportsRequest", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_DoubleclicksearchReportsRequest_580070,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsRequest_580071,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGenerate_580084 = ref object of OpenApiRestCall_579424
proc url_DoubleclicksearchReportsGenerate_580086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchReportsGenerate_580085(path: JsonNode;
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
  var valid_580087 = query.getOrDefault("fields")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "fields", valid_580087
  var valid_580088 = query.getOrDefault("quotaUser")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "quotaUser", valid_580088
  var valid_580089 = query.getOrDefault("alt")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = newJString("json"))
  if valid_580089 != nil:
    section.add "alt", valid_580089
  var valid_580090 = query.getOrDefault("oauth_token")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "oauth_token", valid_580090
  var valid_580091 = query.getOrDefault("userIp")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "userIp", valid_580091
  var valid_580092 = query.getOrDefault("key")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "key", valid_580092
  var valid_580093 = query.getOrDefault("prettyPrint")
  valid_580093 = validateParameter(valid_580093, JBool, required = false,
                                 default = newJBool(true))
  if valid_580093 != nil:
    section.add "prettyPrint", valid_580093
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

proc call*(call_580095: Call_DoubleclicksearchReportsGenerate_580084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates and returns a report immediately.
  ## 
  let valid = call_580095.validator(path, query, header, formData, body)
  let scheme = call_580095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580095.url(scheme.get, call_580095.host, call_580095.base,
                         call_580095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580095, url, valid)

proc call*(call_580096: Call_DoubleclicksearchReportsGenerate_580084;
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
  var query_580097 = newJObject()
  var body_580098 = newJObject()
  add(query_580097, "fields", newJString(fields))
  add(query_580097, "quotaUser", newJString(quotaUser))
  add(query_580097, "alt", newJString(alt))
  if reportRequest != nil:
    body_580098 = reportRequest
  add(query_580097, "oauth_token", newJString(oauthToken))
  add(query_580097, "userIp", newJString(userIp))
  add(query_580097, "key", newJString(key))
  add(query_580097, "prettyPrint", newJBool(prettyPrint))
  result = call_580096.call(nil, query_580097, nil, nil, body_580098)

var doubleclicksearchReportsGenerate* = Call_DoubleclicksearchReportsGenerate_580084(
    name: "doubleclicksearchReportsGenerate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/reports/generate",
    validator: validate_DoubleclicksearchReportsGenerate_580085,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGenerate_580086,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGet_580099 = ref object of OpenApiRestCall_579424
proc url_DoubleclicksearchReportsGet_580101(protocol: Scheme; host: string;
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

proc validate_DoubleclicksearchReportsGet_580100(path: JsonNode; query: JsonNode;
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
  var valid_580102 = path.getOrDefault("reportId")
  valid_580102 = validateParameter(valid_580102, JString, required = true,
                                 default = nil)
  if valid_580102 != nil:
    section.add "reportId", valid_580102
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
  var valid_580103 = query.getOrDefault("fields")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "fields", valid_580103
  var valid_580104 = query.getOrDefault("quotaUser")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "quotaUser", valid_580104
  var valid_580105 = query.getOrDefault("alt")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = newJString("json"))
  if valid_580105 != nil:
    section.add "alt", valid_580105
  var valid_580106 = query.getOrDefault("oauth_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "oauth_token", valid_580106
  var valid_580107 = query.getOrDefault("userIp")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "userIp", valid_580107
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("prettyPrint")
  valid_580109 = validateParameter(valid_580109, JBool, required = false,
                                 default = newJBool(true))
  if valid_580109 != nil:
    section.add "prettyPrint", valid_580109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580110: Call_DoubleclicksearchReportsGet_580099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Polls for the status of a report request.
  ## 
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_DoubleclicksearchReportsGet_580099; reportId: string;
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
  var path_580112 = newJObject()
  var query_580113 = newJObject()
  add(query_580113, "fields", newJString(fields))
  add(query_580113, "quotaUser", newJString(quotaUser))
  add(query_580113, "alt", newJString(alt))
  add(query_580113, "oauth_token", newJString(oauthToken))
  add(query_580113, "userIp", newJString(userIp))
  add(query_580113, "key", newJString(key))
  add(path_580112, "reportId", newJString(reportId))
  add(query_580113, "prettyPrint", newJBool(prettyPrint))
  result = call_580111.call(path_580112, query_580113, nil, nil, nil)

var doubleclicksearchReportsGet* = Call_DoubleclicksearchReportsGet_580099(
    name: "doubleclicksearchReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{reportId}",
    validator: validate_DoubleclicksearchReportsGet_580100,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGet_580101,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGetFile_580114 = ref object of OpenApiRestCall_579424
proc url_DoubleclicksearchReportsGetFile_580116(protocol: Scheme; host: string;
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

proc validate_DoubleclicksearchReportsGetFile_580115(path: JsonNode;
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
  var valid_580117 = path.getOrDefault("reportFragment")
  valid_580117 = validateParameter(valid_580117, JInt, required = true, default = nil)
  if valid_580117 != nil:
    section.add "reportFragment", valid_580117
  var valid_580118 = path.getOrDefault("reportId")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "reportId", valid_580118
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
  var valid_580119 = query.getOrDefault("fields")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "fields", valid_580119
  var valid_580120 = query.getOrDefault("quotaUser")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "quotaUser", valid_580120
  var valid_580121 = query.getOrDefault("alt")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("json"))
  if valid_580121 != nil:
    section.add "alt", valid_580121
  var valid_580122 = query.getOrDefault("oauth_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "oauth_token", valid_580122
  var valid_580123 = query.getOrDefault("userIp")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "userIp", valid_580123
  var valid_580124 = query.getOrDefault("key")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "key", valid_580124
  var valid_580125 = query.getOrDefault("prettyPrint")
  valid_580125 = validateParameter(valid_580125, JBool, required = false,
                                 default = newJBool(true))
  if valid_580125 != nil:
    section.add "prettyPrint", valid_580125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580126: Call_DoubleclicksearchReportsGetFile_580114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Downloads a report file encoded in UTF-8.
  ## 
  let valid = call_580126.validator(path, query, header, formData, body)
  let scheme = call_580126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580126.url(scheme.get, call_580126.host, call_580126.base,
                         call_580126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580126, url, valid)

proc call*(call_580127: Call_DoubleclicksearchReportsGetFile_580114;
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
  var path_580128 = newJObject()
  var query_580129 = newJObject()
  add(query_580129, "fields", newJString(fields))
  add(path_580128, "reportFragment", newJInt(reportFragment))
  add(query_580129, "quotaUser", newJString(quotaUser))
  add(query_580129, "alt", newJString(alt))
  add(query_580129, "oauth_token", newJString(oauthToken))
  add(query_580129, "userIp", newJString(userIp))
  add(query_580129, "key", newJString(key))
  add(path_580128, "reportId", newJString(reportId))
  add(query_580129, "prettyPrint", newJBool(prettyPrint))
  result = call_580127.call(path_580128, query_580129, nil, nil, nil)

var doubleclicksearchReportsGetFile* = Call_DoubleclicksearchReportsGetFile_580114(
    name: "doubleclicksearchReportsGetFile", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/reports/{reportId}/files/{reportFragment}",
    validator: validate_DoubleclicksearchReportsGetFile_580115,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGetFile_580116,
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
